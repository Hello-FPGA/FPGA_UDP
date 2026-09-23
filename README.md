# HELLO-FPGA KU5P UDP 以太网回环示例工程

## 1. 项目概述

本项目为 HELLO-FPGA KU5P 开发板上的 **UDP 以太网回环** 示例，基于 Xilinx Kintex UltraScale+ KU5P FPGA。项目实现了完整的硬件级 UDP/IP/Ethernet 协议栈，收到 UDP 数据包后自动将载荷原路回发（Loopback），用于验证不同速率以太网接口的功能。

四个子工程共享相同的核心协议栈逻辑（`fpga_core.v` 及 `rtl/`、`lib/` 下的公共模块），**核心差异在于以太网 IP 核选型、接口速率、数据位宽及时钟方案**。


项目用到的主要硬件：

1、https://img-grab.com/productinfo/258639.html Hello-FPGA-KU5P FPGA开发板，其它型号的支持会应要求增加支持

2、https://img-grab.com/productinfo/259279.html Hello-FPGA-FMC-QSFP-X2 FMC子卡

3、光纤线缆与网卡，具体型号在doc/test_report中有详细描述



---

## 2. 基本概念

### 2.1 网络协议相关

#### UDP（User Datagram Protocol，用户数据报协议）
UDP 是一种**无连接、不可靠但低延迟**的传输层协议（RFC 768）。与 TCP 不同，UDP 不建立连接、不保证送达、不进行拥塞控制，因此开销极小、时延极低，非常适合 FPGA 硬件实现和高频交易、实时数据采集等场景。

UDP 数据包结构：
```
+--------+--------+--------+----------+
| 源端口  | 目的端口 |  长度  |  校验和   |  ← UDP 头部（8 字节）
+--------+--------+--------+----------+
|                                  |
|           载荷 (Payload)          |  ← 用户数据
|                                  |
+----------------------------------+
```

本项目中，FPGA 监听 **UDP 目的端口 1234**，收到数据后将载荷原样回发，形成回环（Loopback）。

#### IP（Internet Protocol，网际协议）
IP 是网络层协议，负责将数据包从源地址路由到目的地址。本项目使用 **IPv4**，关键信息包括：
- **源 IP / 目的 IP**：32 位地址，如 `192.168.1.128`
- **协议号**：UDP 的协议号为 **17**，IP 头部通过此字段标识上层协议类型
- **TTL（Time To Live）**：数据包最大跳数，本项目设为 64
- **头部校验和**：IP 头部的完整性校验

#### Ethernet（以太网）
以太网是最广泛使用的局域网（LAN）技术，定义了物理层和数据链路层的规范。以太网帧结构：
```
+----------------+----------------+---------+--------+------+
| 目的 MAC (6B)   | 源 MAC (6B)    | 类型 (2B)| 载荷   | FCS  |
+----------------+----------------+---------+--------+------+
                                            46~1500B   4B
```
- **MAC 地址**：48 位硬件地址，如 `02:00:00:00:00:00`，用于局域网内设备识别
- **类型字段**：标识上层协议，IPv4 为 `0x0800`，ARP 为 `0x0806`
- **FCS（Frame Check Sequence）**：4 字节 CRC-32 校验，用于检测帧传输错误
- **最小帧长 64 字节**：以太网要求帧最短 64 字节（不含前导码），不足时需填充

#### ARP（Address Resolution Protocol，地址解析协议）
ARP 用于将 IP 地址解析为 MAC 地址。当 FPGA 需要向某个 IP 发送数据时，首先需要知道对应的 MAC 地址。ARP 的工作流程：
1. 查询本地 **ARP 缓存表**，看是否已有该 IP 对应的 MAC 地址
2. 若未命中，发送 **ARP 请求广播**（"谁有 192.168.1.1？请告诉 192.168.1.128"）
3. 目标设备回复 **ARP 应答**（"192.168.1.1 的 MAC 是 xx:xx:xx:xx:xx:xx"）
4. 缓存结果后用于后续通信

本项目中 `udp_complete_64` 内置了 ARP 模块，会自动处理 ARP 请求和应答。

#### 协议栈层次关系
```
应用数据
  ↓
UDP 头部 + 数据         ← 传输层（端口号、校验和）
  ↓
IP 头部 + UDP + 数据     ← 网络层（IP 地址、路由）
  ↓
MAC 头部 + IP + 数据 + FCS ← 数据链路层（MAC 地址、帧校验）
  ↓
物理层信号（光/电信号）    ← 物理层（GT 收发器、光模块）
```

#### Loopback（回环）
回环是指设备将收到的数据原样发送回去的测试机制。本项目中 FPGA 收到目的端口为 1234 的 UDP 包后，交换源/目的 IP 和端口，将载荷通过 FIFO 缓存后送回 TX 通道发出，用于验证数据通路的完整性。

---

### 2.2 FPGA 与硬件相关

#### GT（Gigabit Transceiver，千兆级收发器）
GT 是 FPGA 内部的高速串行收发器硬核，每个 GT 通道包含独立的 TX/RX 模块，支持多种串行协议（如 Ethernet、PCIe、SATA 等）。关键参数：
- **线速（Line Rate）**：单个 GT 通道的数据传输速率，如 10 Gbps、25 Gbps
- **差分对**：每个 GT 通道需要一对 TX 差分引脚和一对 RX 差分引脚
- **参考时钟**：GT 需要外部提供参考时钟（本项目为 156.25 MHz），内部 PLL 据此生成收发时钟

#### MMCM（Mixed-Mode Clock Manager，混合模式时钟管理器）
MMCM 是 FPGA 内部的时钟管理资源，可对输入时钟进行分频、倍频、移相等操作，生成多个不同频率的输出时钟。本项目中 `clk_wiz_0` 即基于 MMCM：
- 输入：板载 **200 MHz** LVDS 差分晶振
- 输出1：**100 MHz**，用于以太网 IP 的管理时钟（DCLK）
- 输出2：**156.25 MHz** 或 **390.625 MHz**，用于逻辑时钟

#### AXI-Stream（AXI4-Stream）
AXI-Stream 是 ARM AMBA 总线协议族中的流式数据传输协议，广泛用于 FPGA 内部模块间的数据交互。核心信号：
| 信号 | 说明 |
|---|---|
| `tdata` | 数据总线（如 64-bit、256-bit、512-bit） |
| `tkeep` | 字节有效指示，每位对应 `tdata` 中 1 个字节 |
| `tvalid` | 数据有效信号，高表示 `tdata` 上有有效数据 |
| `tready` | 接收就绪信号，高表示接收方可以接受数据（反压机制） |
| `tlast` | 帧结束标志，高表示当前为帧的最后一个数据拍 |
| `tuser` | 用户自定义信号，常用于标记坏帧、携带时间戳等 |

本项目中，以太网 MAC IP 与协议栈之间均通过 AXI-Stream 接口传输数据。

#### 64B/66B 编码
64B/66B 是以太网物理层使用的线路编码方案。每 64 位原始数据编码为 66 位传输码字（添加 2 位同步头），用于：
- 实现时钟恢复（同步头帮助接收端定位数据边界）
- 保证直流平衡和足够的跳变密度
- 编码开销仅 3.125%（2/64），远优于传统 8B/10B 的 20% 开销

#### BASE-R / BASE-KR
- **BASE-R**：基于 64B/66B 编码的以太网物理层规范，用于 SFP/SFP28 等光模块接口
- **BASE-KR**：BASE-R 的背板/铜缆版本，同样使用 64B/66B 编码，但电气特性不同，适用于 PCB 走线或铜缆连接

#### RS-FEC（Reed-Solomon Forward Error Correction，里德-所罗门前向纠错）
RS-FEC 是一种强大的前向纠错编码技术，100G 以太网中广泛使用。它在发送端添加冗余校验数据，接收端利用这些冗余信息自动纠正传输中产生的误码，从而在不增加发射功率的情况下显著降低误码率（BER）。100G CMAC 中启用了 RS-FEC。

#### SFP+ / QSFP+ / QSFP28
常见的光模块封装形式：
| 封装 | 通道数 | 单通道速率 | 总速率 | 典型应用 |
|---|---|---|---|---|
| SFP+ | 1 | 10 Gbps | 10 Gbps | 10G 以太网 |
| SFP28 | 1 | 25 Gbps | 25 Gbps | 25G 以太网 |
| QSFP+ | 4 | 10 Gbps | 40 Gbps | 40G 以太网 |
| QSFP28 | 4 | 25 Gbps | 100 Gbps | 100G 以太网 |

#### MAC（Media Access Control，介质访问控制）
MAC 是以太网数据链路层的核心子层，负责：
- 帧的封装与解封装（添加/去除 MAC 头部和 FCS）
- 介质访问控制（决定何时可以发送数据）
- 帧的发送与接收

本项目中的 "MAC IP" 指 Xilinx 提供的以太网 MAC 硬核 IP（如 XXV Ethernet、CMAC），它们实现了物理层编码和 MAC 层功能，对外暴露 AXI-Stream 用户接口。

#### FCS（Frame Check Sequence，帧校验序列）
FCS 是以太网帧尾部的 4 字节 CRC-32 校验值，用于检测帧在传输过程中是否发生误码。发送端由 MAC IP 自动计算并插入，接收端自动校验。本项目中各 MAC IP 均配置为自动处理 FCS（发送插入、接收校验并剥离）。

---

## 3. 四个工程总览

| 参数 | xxvethernet_10g | xxvethernet_25g | ethernet_40g | ethernet_100g |
|---|---|---|---|---|
| **以太网速率** | 10 Gbps | 25 Gbps | 40 Gbps | 100 Gbps |
| **Vivado IP 核** | xxv_ethernet | xxv_ethernet | l_ethernet | cmac_usplus |
| **编码方式** | BASE-R | BASE-R | BASE-KR | CAUI4 + RS-FEC |
| **GT 通道数** | 1 | 1 | 4 | 4 |
| **GT 参考时钟** | 156.25 MHz | 156.25 MHz | — (内部 PLL) | 156.25 MHz |
| **MAC AXIS 数据位宽** | 64-bit | 64-bit | 256-bit | 512-bit |
| **MAC AXIS KEEP 位宽** | 8-bit | 8-bit | 32-bit | 64-bit |
| **逻辑时钟 (logic_clk)** | 156.25 MHz (MAC 恢复时钟) | 390.625 MHz (MMCM) | 390.625 MHz (MMCM) | 390.625 MHz (MMCM) |
| **MMCM 输出2 (clk_out2)** | 156.25 MHz | 390.625 MHz | 390.625 MHz | 390.625 MHz |
| **物理连接器** | SFP+ | SFP+ | QSFP+ | QSFP+ |
| **需要位宽转换** | 否 | 否 | 是 (256↔64) | 是 (512↔64) |
| **ethernet_adapter 模块** | 无 | 无 | 有 | 有 |

---

## 4. 各 RTL 模块说明

### 4.1 公共模块（四个工程共用）

#### `fpga.v` — FPGA 顶层模块
- 实例化时钟管理模块 `clk_wiz_0`，将板载 200MHz LVDS 晶振分频为系统所需的各种时钟
- 实例化同步复位模块 `sync_reset`，确保复位信号与系统时钟同步
- 实例化以太网 IP 封装模块（`xxv_ethernet` / `ethernet_40g_wrapper` / `cmac_usplus_wrapper`）
- 实例化核心逻辑模块 `fpga_core`
- 连接 FPGA 引脚（GT 收发器差分对、参考时钟等）

#### `fpga_core.v` — FPGA 核心逻辑
- 实例化 `eth_mac_10g_fifo`：MAC 层 AXI 异步 FIFO，完成 MAC 时钟域与逻辑时钟域之间的数据跨时钟域传输
- 实例化 `eth_axis_rx`：将 AXI-Stream 原始以太网帧解析为结构化的帧头 + 载荷格式（分离目的 MAC、源 MAC、类型字段）
- 实例化 `eth_axis_tx`：将结构化帧头 + 载荷重新组装为 AXI-Stream 以太网帧
- 实例化 `udp_complete_64`：完整的 UDP/IP/ARP 协议栈（64-bit 数据通路），包含：
  - Ethernet 帧收发
  - IP 包收发与校验
  - ARP 缓存管理（自动响应 ARP 请求）
  - UDP 包收发与校验和计算
- 实例化 `axis_fifo`（深度 8192）：UDP 载荷 FIFO 缓存，用于 RX→TX 的回环数据暂存
- 实现 **UDP 回环逻辑**：检测目的端口为 1234 的 UDP 包，将载荷通过 FIFO 送回 TX 通道

#### `eth_mac_10g_fifo.v` — 10G 以太网 MAC AXI 异步 FIFO
- 内部实例化两个 `axis_async_fifo_adapter`（TX FIFO 和 RX FIFO）
- TX FIFO：从逻辑时钟域 → MAC 时钟域，深度 4096，支持帧 FIFO 模式
- RX FIFO：从 MAC 时钟域 → 逻辑时钟域，深度 4096，支持帧 FIFO 模式
- 实现跨时钟域的 AXI-Stream 数据传输与位宽适配

#### `rtl/` 目录 — 公共协议栈库
来自 [alexforencich/verilog-ethernet](https://github.com/alexforenclick/verilog-ethernet) 开源项目，主要模块包括：

| 模块 | 功能 |
|---|---|
| `udp_complete_64` | 完整的 UDP/IP/ARP 协议栈（64-bit 通路） |
| `udp_64` / `udp_checksum_gen_64` | UDP 包处理与校验和生成 |
| `ip_complete_64` / `ip_64` | IP 层协议处理 |
| `arp` / `arp_cache` / `arp_eth_rx` / `arp_eth_tx` | ARP 协议与 MAC 地址解析 |
| `eth_axis_rx` / `eth_axis_tx` | 以太网帧 AXI-Stream 解析/组装 |
| `axis_eth_fcs_insert_64` / `axis_eth_fcs_check_64` | 以太网 FCS 帧校验序列插入/校验 |
| `axis_xgmii_tx_64` / `axis_xgmii_rx_64` | XGMII 接口与 AXI-Stream 转换 |
| `xgmii_baser_enc_64` / `xgmii_baser_dec_64` | 64B/66B 编码/解码 |
| `sync_reset` | 同步复位生成 |
| `axis_fifo` / `axis_async_fifo_adapter` | AXI-Stream FIFO 与异步 FIFO 适配器 |
| `axis_frame_length_adjust` | 以太网帧长度调整（填充/截断） |

---

### 4.2 xxvethernet_10g 专有模块

#### `xxv_ethernet.v` — XXV Ethernet IP 封装（10G）
- 实例化 Vivado IP `xxv_ethernet_0`（XXV Ethernet v4.1）
- 配置参数：**10 Gbps**，BASE-R 编码，单通道 GT
- 提供 AXI-Stream 64-bit TX/RX 用户接口
- 内部集成 `axis_frame_length_adjust` 模块（参数 `NEDD_ADJUST_LENTH="TRUE"`），确保 TX 帧最小 64 字节
- 连接 GT 差分收发器引脚和参考时钟

#### `IP/xxv_ethernet_10g.tcl` — IP 配置脚本
- IP 名称：`xxv_ethernet`
- `LINE_RATE` = 10（Gbps）
- `GT_REF_CLK_FREQ` = 156.25 MHz
- `BASE_R_KR` = BASE-R

#### 时钟方案
- `clk_wiz_0`：200MHz → 100MHz（DCLK/管理时钟）+ 156.25MHz（逻辑时钟）
- 逻辑时钟直接使用以太网 IP 恢复的 `tx_clk_out_0`（156.25MHz），与 MAC 时钟同域，无需跨时钟域

---

### 4.3 xxvethernet_25g 专有模块

#### `xxv_ethernet.v` — XXV Ethernet IP 封装（25G）
- 与 10G 工程使用相同的封装模块结构
- 实例化 Vivado IP `xxv_ethernet_0`，配置参数：**25 Gbps**，BASE-R 编码，单通道 GT
- AXI-Stream 64-bit 接口，内部集成帧长度调整

#### `IP/xxv_ethernet_0.tcl` — IP 配置脚本
- IP 名称：`xxv_ethernet`
- `LINE_RATE` = 25（Gbps）
- `GT_REF_CLK_FREQ` = 156.25 MHz
- `BASE_R_KR` = BASE-R

#### 时钟方案
- `clk_wiz_0`：200MHz → 100MHz（DCLK）+ 390.625MHz（逻辑时钟）
- 逻辑时钟使用 MMCM 输出的 390.625MHz，与 MAC 恢复时钟（~390.625MHz）频率一致
- `fpga.v` 中 `fpga_core` 使用 `clk_390mhz_int` 作为逻辑时钟

---

### 4.4 ethernet_40g 专有模块

#### `ethernet_40g_wrapper.v` — 40G Ethernet IP 封装
- 实例化 Vivado IP `l_ethernet_0`（40G Ethernet v3.3）
- 配置参数：**40 Gbps**，BASE-KR 编码，4 通道 GT
- AXI-Stream **256-bit** TX/RX 用户接口（KEEP 宽度 32-bit）
- 4 对 GT 差分引脚（lane 0~3）直接展开连接
- 提供完整的 TX/RX 控制信号和统计信号接口

#### `ethernet_adapter.v` — 位宽转换适配器（256-bit ↔ 64-bit）
- **RX 方向**：`axis_fifo_adapter`（256-bit → 64-bit），深度 8192，将 MAC 输出的 256-bit 数据流降速为 64-bit 供 UDP 协议栈使用
- **TX 方向**：先经 `axis_frame_length_adjust`（帧长度调整，最小 64 字节，最大 9216 字节），再经 `axis_fifo_adapter`（64-bit → 256-bit）升速为 256-bit 送入 MAC
- 实现 MAC 时钟域与逻辑时钟域之间的异步 FIFO 跨时钟域传输

#### `IP/l_ethernet_0.tcl` — IP 配置脚本
- IP 名称：`l_ethernet`（40G Ethernet）
- `LINE_RATE` = 40（Gbps）
- `BASE_R_KR` = BASE-KR
- `DATA_PATH_INTERFACE` = 256-bit Regular AXI4-Stream

#### 时钟方案
- `clk_wiz_0`：200MHz → 100MHz（DCLK）+ 390.625MHz（逻辑时钟）
- `clk_axis` 来自 `l_ethernet_0` 的 `tx_clk_out_0`，作为 MAC 侧时钟
- `fpga_core` 使用 MMCM 输出的 `clk_312mhz_int`（实际 390.625MHz）

---

### 4.5 ethernet_100g 专有模块

#### `cmac_usplus_wrapper.v` — 100G CMAC IP 封装
- 实例化 Vivado IP `cmac_usplus_0`（CMAC v3.1）
- 配置参数：**100 Gbps**，CAUI4 模式（4 通道），含 **RS-FEC**（前向纠错）
- AXI-Stream **512-bit** TX/RX 用户接口（KEEP 宽度 64-bit）
- 4 对 GT 差分引脚
- 启用了 RS-FEC 的发送和接收（`ctl_tx_rsfec_enable` / `ctl_rx_rsfec_enable` / `ctl_rx_rsfec_enable_correction` / `ctl_rx_rsfec_enable_indication` 全部置 1）
- 实例化 `ila_600`（ILA 逻辑分析仪）用于在线调试 MAC 层状态信号

#### `ethernet_adapter.v` — 位宽转换适配器（512-bit ↔ 64-bit）
- 结构与 40G 工程的 adapter 相同，但数据位宽不同：
  - **RX 方向**：`axis_fifo_adapter`（512-bit → 64-bit）
  - **TX 方向**：`axis_frame_length_adjust` + `axis_fifo_adapter`（64-bit → 512-bit）
- FIFO 深度 8192

#### `IP/cmac_usplus_0.tcl` — IP 配置脚本
- IP 名称：`cmac_usplus`（100G Ethernet MAC）
- `CMAC_CAUI4_MODE` = 1（CAUI-4 模式）
- `GT_REF_CLK_FREQ` = 156.25 MHz
- `INCLUDE_RS_FEC` = 1（启用 RS-FEC）
- `USER_INTERFACE` = AXIS
- `TX_FRAME_CRC_CHECKING` = Enable FCS Insertion

#### `IP/ila_1024.tcl` / `IP/ila_axis.tcl` — ILA 调试核配置
- 100G 工程额外集成了 ILA（Integrated Logic Analyzer）用于调试 MAC 状态和 AXIS 数据流

#### 时钟方案
- `clk_wiz_0`：200MHz → 100MHz（DCLK/DRP 时钟）+ 390.625MHz（逻辑时钟）
- `clk_axis` 来自 CMAC 的 `gt_txusrclk2`（~322.266 MHz），作为 MAC 侧时钟
- `fpga_core` 使用 MMCM 输出的 `clk_312mhz_int`（实际 390.625MHz）
- QSFP 模块控制：`qsfp_lpmode=0`（低功耗模式关闭），`qsfp_resetn=1`（复位释放）

---

## 5. 工程差异详解

### 5.1 以太网 IP 核差异

| 特性 | xxv_ethernet (10G/25G) | l_ethernet (40G) | cmac_usplus (100G) |
|---|---|---|---|
| IP 类型 | XXV Ethernet | 40G Ethernet | 100G CMAC |
| 适用速率 | 1~25 Gbps | 40 Gbps | 100 Gbps |
| GT 通道数 | 1 | 4 | 4 (CAUI4) |
| 编码 | 64B/66B BASE-R | 64B/66B BASE-KR | 64B/66B + RS-FEC |
| 用户接口位宽 | 64-bit | 256-bit | 512-bit |
| FCS 处理 | IP 内部处理 | IP 内部处理 | IP 内部处理 |
| RS-FEC | 不支持 | 不支持 | 支持（已启用） |

### 5.2 数据通路差异

**10G / 25G（无位宽转换）：**
```
xxv_ethernet (64-bit AXIS) ←→ fpga_core (64-bit 协议栈)
                               └─ eth_mac_10g_fifo (异步 FIFO, 跨时钟域)
```
MAC IP 直接输出 64-bit 数据，与 UDP 协议栈位宽匹配，无需额外转换。

**40G（256-bit → 64-bit 转换）：**
```
l_ethernet (256-bit AXIS) ←→ ethernet_adapter ←→ fpga_core (64-bit 协议栈)
                              ├─ RX: axis_fifo_adapter (256→64)
                              └─ TX: frame_length_adjust + axis_fifo_adapter (64→256)
```

**100G（512-bit → 64-bit 转换）：**
```
cmac_usplus (512-bit AXIS) ←→ ethernet_adapter ←→ fpga_core (64-bit 协议栈)
                               ├─ RX: axis_fifo_adapter (512→64)
                               └─ TX: frame_length_adjust + axis_fifo_adapter (64→512)
```

### 5.3 时钟方案差异

| 工程 | MMCM clk_out1 | MMCM clk_out2 | MAC 恢复时钟 | fpga_core 时钟 |
|---|---|---|---|---|
| xxvethernet_10g | 100 MHz | 156.25 MHz | tx_clk_out (156.25M) | 156.25 MHz (= MAC 时钟) |
| xxvethernet_25g | 100 MHz | 390.625 MHz | rx_clk_out (~390M) | 390.625 MHz |
| ethernet_40g | 100 MHz | 390.625 MHz | tx_clk_out (~312M) | 390.625 MHz |
| ethernet_100g | 100 MHz | 390.625 MHz | gt_txusrclk2 (~322M) | 390.625 MHz |

- **10G**：逻辑时钟直接使用 MAC 恢复时钟，同频同相，无需跨时钟域 FIFO（`eth_mac_10g_fifo` 仍用于帧缓存）
- **25G/40G/100G**：逻辑时钟由 MMCM 产生（390.625MHz），与 MAC 恢复时钟异步，`eth_mac_10g_fifo` 或 `ethernet_adapter` 中的异步 FIFO 实现跨时钟域传输

### 5.4 物理接口差异

| 工程 | 连接器类型 | GT 差分对 | 光模块 |
|---|---|---|---|
| xxvethernet_10g | SFP+ | 1 对 TX + 1 对 RX | 10G SFP+ |
| xxvethernet_25g | SFP+ | 1 对 TX + 1 对 RX | 25G SFP28 |
| ethernet_40g | QSFP+ | 4 对 TX + 4 对 RX | 40G QSFP+ |
| ethernet_100g | QSFP+ | 4 对 TX + 4 对 RX | 100G QSFP28 |

---

## 6. 网络配置

所有工程的网络参数相同（定义在 `fpga_core.v` 中）：

| 参数 | 值 |
|---|---|
| 本地 MAC | `02:00:00:00:00:00` |
| 本地 IP | `192.168.1.128` |
| 网关 IP | `192.168.1.1` |
| 子网掩码 | `255.255.255.0` |
| UDP 回环端口 | `1234` |

---

## 7. 目录结构

```
hellofpga_ku5p/
├── xxvethernet_10g/        # 10G 以太网工程
│   ├── IP/                  # Vivado IP TCL 配置脚本
│   ├── RTL/                 # 用户 RTL 源码
│   └── tcl/                 # Vivado 工程文件及构建产物
├── xxvethernet_25g/        # 25G 以太网工程
│   ├── IP/
│   ├── RTL/
│   └── tcl/
├── ethernet_40g/           # 40G 以太网工程
│   ├── IP/
│   ├── RTL/
│   └── tcl/
├── ethernet_100g/          # 100G 以太网工程
│   ├── IP/
│   ├── RTL/
│   └── tcl/
├── clock.xdc               # 时钟约束
├── qsfp.xdc                # QSFP 引脚约束
├── qsfp2.xdc               # QSFP2 引脚约束
├── sfp.xdc                 # SFP 引脚约束
└── rgmii.xdc               # RGMII 引脚约束
```

---

## 8. 构建与使用

1. 使用 Vivado 2022.2 打开对应工程目录下的 `.xpr` 文件
2. 运行 `Generate Bitstream` 完成综合、实现和比特流生成
3. 通过 JTAG 下载 `fpga.bit` 到 FPGA
4. 使用 PC 向 FPGA 的 IP 地址 `192.168.1.128` 的 UDP 端口 `1234` 发送数据
5. FPGA 会将收到的 UDP 载荷原样回发

---

## 9. 许可

RTL 源码基于 Alex Forencich 的 [verilog-ethernet](https://github.com/alexforenclick/verilog-ethernet) 开源项目（MIT License）。

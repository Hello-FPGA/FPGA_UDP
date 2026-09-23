@echo off
setlocal EnableDelayedExpansion

rem =====================================================================
rem  build.bat - UDP 40G loopback project auto builder
rem  Usage: double-click or run in cmd, searches local Vivado 2022.2
rem         installation and recreates the Vivado project via
rem         create_project.tcl (IP tcl + RTL sources kept in git).
rem =====================================================================

set "PROJ=udp_40g_loopback"
set "VIVADO_BAT="
set "VIVADO_VER=2022.2"

rem --- 1. search Windows registry (installer records all Vivado versions) ---
for /f "tokens=2,*" %%a in ('reg query "HKLM\SOFTWARE\Xilinx\Vivado\%VIVADO_VER%" /v "Install Path" 2^>nul ^| findstr /i "Install Path"') do (
    if exist "%%b\bin\vivado.bat" set "VIVADO_BAT=%%b\bin\vivado.bat"
)

rem --- 2. fallback: environment variable XILINX_VIVADO ---
if not defined VIVADO_BAT (
    if defined XILINX_VIVADO (
        if exist "%XILINX_VIVADO%\bin\vivado.bat" set "VIVADO_BAT=%XILINX_VIVADO%\bin\vivado.bat"
    )
)

rem --- 3. fallback: common installation directories ---
if not defined VIVADO_BAT (
    for %%d in (
        "C:\Xilinx\Vivado"
        "D:\Xilinx\Vivado"
        "E:\Xilinx\Vivado"
        "F:\Xilinx\Vivado"
        "C:\Program Files\Xilinx\Vivado"
        "D:\Program Files\Xilinx\Vivado"
    ) do (
        if exist "%%~fd\%VIVADO_VER%\bin\vivado.bat" set "VIVADO_BAT=%%~fd\%VIVADO_VER%\bin\vivado.bat"
    )
)

if not defined VIVADO_BAT (
    echo [ERROR] Vivado %VIVADO_VER% not found in registry, XILINX_VIVADO or common paths.
    echo         Please install Vivado %VIVADO_VER% or edit this script to set VIVADO_BAT manually.
    exit /b 1
)

echo [INFO] Using Vivado: %VIVADO_BAT%

rem --- create_project.tcl uses relative paths, must run inside this directory ---
cd /d "%~dp0"

rem --- project is generated into prj\%PROJ% (see -dir prj in create_project.tcl) ---
if not exist prj mkdir prj

"%VIVADO_BAT%" -mode batch -notrace -source create_project.tcl
if errorlevel 1 (
    echo [ERROR] Vivado batch run failed, check messages above.
    exit /b 1
)

if exist "prj\%PROJ%\%PROJ%.xpr" (
    echo [OK] Project created: %~dp0prj\%PROJ%\%PROJ%.xpr
) else (
    echo [ERROR] Project file prj\%PROJ%\%PROJ%.xpr not generated.
    exit /b 1
)

endlocal

@echo off
cd /d "%~dp0"

:: Check for administrative rights and self-elevate if needed
fltmc >nul 2>&1 || net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Start-Process -FilePath '%~f0' -Verb RunAs } catch { exit 1 }"
    exit /b
)

:: Paths to engine and configuration inside the subfolder
set "SUBFOLDER=%~dp0files"
set "ENGINE=%SUBFOLDER%\DO_NOT_CLICK.exe"
set "CONFIG=%SUBFOLDER%\Configuration.xml"

if not exist "%ENGINE%" (
    echo [ERROR] Installation engine not found at: "%ENGINE%"
    pause
    exit /b 1
)

if not exist "%CONFIG%" (
    echo [ERROR] Configuration file not found at: "%CONFIG%"
    pause
    exit /b 1
)

echo Starting Office 365 installation...
"%ENGINE%" /configure "%CONFIG%"
pause

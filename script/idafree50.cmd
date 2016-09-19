@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

if not defined IDAFREE5_URL set IDAFREE5_URL=https://out7.hex-rays.com/files/idafree50.exe

for %%i in ("%IDAFREE5_URL%") do set IDAFREE5_EXE=%%~nxi
set IDAFREE5_DIR=%TEMP%\idafree5
set IDAFREE5_PATH=%IDAFREE5_DIR%\%IDAFREE5_EXE%

echo ==^> Creating "%IDAFREE5_DIR%"
mkdir "%IDAFREE5_DIR%"
pushd "%IDAFREE5_DIR%"

if exist "%SystemRoot%\_download.cmd" (
  call "%SystemRoot%\_download.cmd" "%IDAFREE5_URL%" "%IDAFREE5_PATH%"
) else (
  echo ==^> Downloading "%IDAFREE5_URL%" to "%IDAFREE5_PATH%"
  powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%IDAFREE5_URL%', '%IDAFREE5_PATH%')" <NUL
)
if not exist "%IDAFREE5_PATH%" goto exit1

echo ==^> Installing IDA Free 5 %SystemDrive%
"%IDAFREE5_PATH%" /SILENT

@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: "%IDAFREE5_PATH%" -z %SystemDrive%
ver>nul

popd

echo ==^> Removing "%IDAFREE5_DIR%"
rmdir /q /s "%IDAFREE5_DIR%"

:exit0

@ping 127.0.0.1
@ver>nul

@goto :exit

:exit1

@ping 127.0.0.1
@verify other 2>nul

:exit

@echo ==^> Script exiting with errorlevel %ERRORLEVEL%
@exit /b %ERRORLEVEL%


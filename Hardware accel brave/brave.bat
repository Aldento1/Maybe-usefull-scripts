:: Creator: Aldento 
:: Creation Date: 20.02.2025 [DD/MM/YYYY]
:: Last Update: 20.02.2025 [DD/MM/YYYY]
:: This product is provided 'AS IS' 
:: without any warranties or guarantees.
:: --------------------------------------
@echo off
reg add HKLM /F > nul 2>&1
if %errorlevel% neq 0 start "" /wait /I /min powershell -NoProfile -Command start -verb runas "'%~s0'" && exit /b
cls
set "REG_PATH=HKLM\SOFTWARE\Policies\BraveSoftware\Brave" >nul
set "KEY=HardwareAccelerationModeEnabled" >nul

reg query %REG_PATH% /v %KEY% >nul 2>&1
if %errorlevel% neq 0 (
	echo Brave hardware acceleration regkey does not exists.
	echo.
	timeout 1 > nul
	echo exiting in 3 seconds..
	timeout 3 >nul 
	exit
)

for /f "tokens=3" %%A in ('reg query %REG_PATH% /v %KEY% ^| findstr %KEY%') do set VALUE=%%A

if "%VALUE%"=="0x0" (
    echo Enabling hardware acceleration...
    reg add %REG_PATH% /v %KEY% /t REG_DWORD /d 1 /f
    set "text=Hardware acceleration enabled."
) else (
    echo Disabling hardware acceleration...
    reg add %REG_PATH% /v %KEY% /t REG_DWORD /d 0 /f
    set "text=Hardware acceleration disabled."
)

:restart
mode 50,15
cls
echo         ____                                      
echo        ^|  _ \                                     
echo        ^| ^|_) ^|  _ __    __ _  __   __   ___       
echo        ^|  _ ^<  ^| '__^|  / _\ ^| \ \ / /  / _ \      
echo        ^| ^|_) ^| ^| ^|    ^| (_^| ^|  \ V /  ^|  __/      
echo        ^|____/  ^|_^|     \__,_^|   \_/    \___^|      
echo.
echo. %text%
echo.
echo Restart Brave browser, 
echo You should see changes.
echo.
pause
exit

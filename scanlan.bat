@echo off
setlocal enabledelayedexpansion

:: Set your subnet here
set SUBNET=192.168.0

echo Sending pings to each IP in the subnet...
<nul set /p =""
for /l %%i in (1,1,254) do (
    ping %SUBNET%.%%i -n 1 -w 100 > nul
    <nul set /p =.
)
echo..

:: Fetch and display ARP table
echo Fetching ARP table...
echo.
echo IP Address - MAC Address - Hostname
echo ---------------------------------------------

for /f "tokens=1,2" %%a in ('arp -a ^| findstr "%SUBNET%"') do (
    set "ip=%%a"
    set "mac=%%b"
    if "!ip!" NEQ "%SUBNET%.255" (
        for /f "tokens=2 delims=: " %%n in ('nslookup !ip! 2^>nul ^| findstr /C:"Name:"') do (
            set "name=%%n"
        )
        if "!ip!" NEQ "Interface:" (
            if not defined name (
                set name=Unknown
            )
            echo !ip! - !mac! - !name!
        )
        set "name="
    )
)

echo.
echo Process complete.
endlocal

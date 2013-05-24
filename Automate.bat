@ECHO OFF
title Miner Adapter

mode con cols=17 lines=3 > nul

COLOR 0A
ECHO Starting
ECHO Automation

SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

set lineCount=0
for /f "tokens=*" %%a in (Automate\Settings.txt) do call :processline %%a

set Pool=%line0%
set Port=%line1%
set Worker=%line2%
Set Password=%line3%

set Stock=%line4%
set Mine=%line5%

CALL:BuildGUIMiner

set Count=0
set Clock=%Mine%

CALL:KillCG
CALL:KillGUI

Automate\barelyclocked gpu=0 core=%Mine% fan=100 > nul

goto Detect

:Detect

set MinerOld=%Miner%
set Miner=CG
set ClockOld=%Clock%
set Clock=%Mine%

CALL Automate\Presets.bat

IF %Miner%==CG  ( set /a Count=%Count%+1 ) ELSE ( set Count=0 )
IF %Count%==720 ( set Count=0 & CALL:KillCG & CALL:StartCG )

cls
call :ColorText 0F "Miner"
IF %Miner%==CG ( set Color=0A ) ELSE ( IF %Miner%==GUI ( set Color=0E ) ELSE ( set Color=0C ))
call :ColorText %Color% "  %Miner%Miner"
ECHO.
call :ColorText 0F "Clock"
IF %Clock%==%Mine% ( set Color=0A ) ELSE ( set Color=0E )
call :ColorText %Color% "  %Clock%"

IF %Miner%==%MinerOld% ( goto Detect ) ELSE ( CALL:Kill & CALL:Start )

IF NOT %Clock%==%ClockOld% Automate\barelyclocked gpu=0 core=%Clock% > nul

TIMEOUT /T 5 > nul

goto Detect

:BuildGUIMiner

IF NOT EXIST %AppData%\poclbm ( MKDIR %AppData%\poclbm)

ECHO {                                             >  %AppData%\poclbm\poclbm.ini
ECHO     "profiles": [                             >> %AppData%\poclbm\poclbm.ini
ECHO         {                                     >> %AppData%\poclbm\poclbm.ini
ECHO             "username": "%Worker%",           >> %AppData%\poclbm\poclbm.ini
ECHO             "balance_auth_token": "",         >> %AppData%\poclbm\poclbm.ini
ECHO             "name": "Slush",                  >> %AppData%\poclbm\poclbm.ini
ECHO             "hostname": "%Pool%",             >> %AppData%\poclbm\poclbm.ini
ECHO             "external_path": "",              >> %AppData%\poclbm\poclbm.ini
ECHO             "affinity_mask": 0,               >> %AppData%\poclbm\poclbm.ini
ECHO             "flags": "-v -w256 -f100",        >> %AppData%\poclbm\poclbm.ini
ECHO             "autostart": true,                >> %AppData%\poclbm\poclbm.ini
ECHO             "device": 0,                      >> %AppData%\poclbm\poclbm.ini
ECHO             "password": "%Password%",         >> %AppData%\poclbm\poclbm.ini
ECHO             "port": "%Port%"                  >> %AppData%\poclbm\poclbm.ini
ECHO         }                                     >> %AppData%\poclbm\poclbm.ini
ECHO     ],                                        >> %AppData%\poclbm\poclbm.ini
ECHO     "show_opencl_warning": true,              >> %AppData%\poclbm\poclbm.ini
ECHO     "start_minimized": true                   >> %AppData%\poclbm\poclbm.ini
ECHO }                                             >> %AppData%\poclbm\poclbm.ini

GOTO:EOF

:Kill

IF %Miner%==CG ( CALL:KillGUI ) ELSE ( CALL:KillCG )

GOTO:EOF

:KillCG

tasklist /nh /fi "imagename eq cgminer.exe" | find /i "cgminer.exe" > nul && (
     TASKKILL /F /IM "cgminer.exe" > nul
)

GOTO:EOF

:KillGUI

tasklist /nh /fi "imagename eq guiminer.exe" | find /i "guiminer.exe" > nul && (
     TASKKILL /F /IM "guiminer.exe" > nul
)
tasklist /nh /fi "imagename eq poclbm.exe" | find /i "poclbm.exe" > nul && (
     TASKKILL /F /IM "poclbm.exe" > nul
)

GOTO:EOF

:Start

IF %Miner%==CG ( CALL:StartCG ) ELSE ( IF %Miner%==GUI CALL:StartGUI )

GOTO:EOF

:StartCG

START "" /min "CGMiner\cgminer.exe" -o %Pool%:%Port% -u %Worker% -p %Password% -I 9 -k diablo -v 1 -w 256 > nul

GOTO:EOF

:StartGUI

START "" "GUIMiner\guiminer.exe"

GOTO:EOF

:ColorText

<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1

GOTO :EOF

:ProcessLine

set line%lineCount%=%*
set /a lineCount+=1

GOTO:EOF
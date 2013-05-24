@ECHO OFF
title Miner Adapter

set Stock=925
set Mine=1080

mode con cols=17 lines=3 > nul

SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

set Count=0
set Clock=1080

set Miner=CG

CALL:KillCG
CALL:KillGUI
CALL:StartCG

Automate\barelyclocked gpu=0 core=%Clock% fan=100 > nul

COLOR 0A
ECHO Starting
ECHO Automation

goto Detect

:Detect

TIMEOUT /T 5 > nul

set MinerOld=%Miner%
set Miner=CG
set ClockOld=%Clock%
set Clock=%Mine%

CALL Automate\Presets.bat

set /a Count=%Count%+1

IF %Count%==360 ( IF %Miner%==CG ( IF %Miner%==%MinerOld% ( set Count=0 & CALL:KillCG & CALL:StartCG )))

cls
call :ColorText 0F "Miner"
IF %Miner%==CG ( set Color=0A ) ELSE ( set Color=0E )
call :ColorText %Color% "  %Miner%Miner"
ECHO.
call :ColorText 0F "Clock"
IF %Clock%==%Mine% ( set Color=0A ) ELSE ( set Color=0E )
call :ColorText %Color% "  %Clock%"

IF %Miner%==%MinerOld% ( goto Detect ) ELSE ( CALL:Kill & CALL:Start )

IF NOT %Clock%==%ClockOld% Automate\barelyclocked gpu=0 core=%Clock% > nul

goto Detect

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

IF %Miner%==CG ( CALL:StartCG ) ELSE ( CALL:StartGUI )

GOTO:EOF

:StartCG

START "" /min "CGMiner\cgminer.exe" -o http://stratum.bitcoin.cz:3333 -u goidox.Michael -p 12qwaszx -I 9 -k diablo -v 1 -w 256 > nul

GOTO:EOF

:StartGUI

START "" /min "GUIMiner\guiminer.exe"

GOTO:EOF

:ColorText

<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1

GOTO :EOF
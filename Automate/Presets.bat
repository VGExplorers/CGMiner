tasklist /nh /fi "imagename eq vlc.exe" | find /i "vlc.exe" > nul && (
     set Miner=GUI
     set Count=0
)
tasklist /nh /fi "imagename eq t6mp.exe" | find /i "t6mp.exe" > nul && (
     set Miner=GUI
     set Clock=%Stock%
     set Count=0
)
tasklist /nh /fi "imagename eq javaw.exe" | find /i "javaw.exe" > nul && (
     set Miner=GUI
     set Clock=%Stock%
     set Count=0
)
tasklist /nh /fi "imagename eq arma2oa.exe" | find /i "arma2oa.exe" > nul && (
     set Miner=GUI
     set Clock=%Stock%
     set Count=0
)
tasklist /nh /fi "imagename eq bf3.exe" | find /i "bf3.exe" > nul && (
     set Miner=GUI
     set Clock=%Stock%
     set Count=0
)
tasklist /nh /fi "imagename eq BFBC2Game.exe" | find /i "BFBC2Game.exe" > nul && (
     set Miner=GUI
     set Clock=%Stock%
     set Count=0
)
tasklist /nh /fi "imagename eq fc3.exe" | find /i "fc3.exe" > nul && (
     set Miner=GUI
     set Clock=%Stock%
     set Count=0
)
tasklist /nh /fi "imagename eq fc3_blooddragon.exe" | find /i "fc3_blooddragon.exe" > nul && (
     set Miner=GUI
     set Clock=%Stock%
     set Count=0
)
tasklist /nh /fi "imagename eq hl2.exe" | find /i "hl2.exe" > nul && (
     set Miner=No 
     set Clock=%Stock%
     set Count=0
)
tasklist /nh /fi "imagename eq metro2033.exe" | find /i "metro2033.exe" > nul && (
     set Miner=GUI
     set Clock=%Stock%
     set Count=0
)
tasklist /nh /fi "imagename eq metroLL.exe" | find /i "metroLL.exe" > nul && (
     set Miner=GUI
     set Clock=%Mine%
     set Count=0
)

GOTO:EOF
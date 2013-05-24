#include <array.au3>
#include <misc.au3>
#include <WinApi.au3>
#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <StaticConstants.au3>
#include <Security.au3>
#include <guibutton.au3>
#include <guiconstantsex.au3>
#include <sendmessage.au3>
#include <memory.au3>
#include <nomadmemory.au3>

dim $adapterstruct[15][3]
$adapterstruct[0][0]="int"
$adapterstruct[0][1]="iSize"
$adapterstruct[0][2]=0
$adapterstruct[1][0]="int"
$adapterstruct[1][1]="iAdapterIndex"
$adapterstruct[1][2]=$adapterstruct[0][2]+4
$adapterstruct[2][0]="char[256]"
$adapterstruct[2][1]="strUDID"
$adapterstruct[2][2]=$adapterstruct[1][2]+4
$adapterstruct[3][0]="int"
$adapterstruct[3][1]="iBusNumber"
$adapterstruct[3][2]=$adapterstruct[2][2]+256
$adapterstruct[4][0]="int"
$adapterstruct[4][1]="iDeviceNumber"
$adapterstruct[4][2]=$adapterstruct[3][2]+4
$adapterstruct[5][0]="int"
$adapterstruct[5][1]="iFunctionNumber"
$adapterstruct[5][2]=$adapterstruct[4][2]+4
$adapterstruct[6][0]="int"
$adapterstruct[6][1]="iVendorID"
$adapterstruct[6][2]=$adapterstruct[5][2]+4
$adapterstruct[7][0]="char[256]"
$adapterstruct[7][1]="strAdapterName"
$adapterstruct[7][2]=$adapterstruct[6][2]+4
$adapterstruct[8][0]="char[256]"
$adapterstruct[8][1]="strDisplayName"
$adapterstruct[8][2]=$adapterstruct[7][2]+256
$adapterstruct[9][0]="int"
$adapterstruct[9][1]="iPresent"
$adapterstruct[9][2]=$adapterstruct[8][2]+256
$adapterstruct[10][0]="int"
$adapterstruct[10][1]="iExist"
$adapterstruct[10][2]=$adapterstruct[9][2]+4
$adapterstruct[11][0]="char[256]"
$adapterstruct[11][1]="strDriverPath"
$adapterstruct[11][2]=$adapterstruct[10][2]+4
$adapterstruct[12][0]="char[256]"
$adapterstruct[12][1]="strDriverPathExt"
$adapterstruct[12][2]=$adapterstruct[11][2]+256
$adapterstruct[13][0]="char[256]"
$adapterstruct[13][1]="strPNPString"
$adapterstruct[13][2]=$adapterstruct[12][2]+256
$adapterstruct[14][0]="int"
$adapterstruct[14][1]="iOSDisplayIndex"
$adapterstruct[14][2]=$adapterstruct[13][2]+256

$dll=""
switch @osarch
	case "X86"
		$dll=dllopen(@systemdir & "\atiadlxx.dll")
	case "X64"
		$dll=dllopen(@systemdir & "\atiadlxy.dll")
	case else
		msgbox(0,"Error","Error: " & @osarch & " is not a valid type!")
endswitch

$malloc=dllcallbackregister("ADL_Main_Memory_Alloc","ptr","int")
$maincreate=dllcall($dll,"int:cdecl","ADL_Main_Control_Create","ptr",dllcallbackgetptr($malloc),"int",1)
$temp=dllcall($dll,"int:cdecl","ADL_Adapter_NumberOfAdapters_Get","int*",0)
$numberofadapters=$temp[1]

;~ $gpus=""
;~ for $i=0 to $numberofadapters-1
;~ 	$temp=dllcall($dll,"int:cdecl","ADL_Adapter_Active_Get","int",$i,"int*",0)
;~ 	if $temp[2] then
;~ 		_redim($gpus,ubound($gpus)+1,2)
;~ 		$temp=dllcall($dll,"int:cdecl","ADL_Adapter_ID_Get","int",$i,"int*",0)
;~ 		$gpus[ubound($gpus)-1][0]=$i
;~ 		$gpus[ubound($gpus)-1][1]=$temp[2]
;~ 	endif
;~ next
;~ consolewrite("Number of active GPUs found: " & ubound($gpus) & "." & @crlf)

$gpus=""
for $i=0 to $numberofadapters-1
	$temp=dllcall($dll,"int:cdecl","ADL_Adapter_ID_Get","int",$i,"int*",0)
	if _arraysearch($gpus,$temp[2])=-1 then
		_redim($gpus,ubound($gpus)+1,2)
		$gpus[ubound($gpus)-1][0]=$i
		$gpus[ubound($gpus)-1][1]=$temp[2]
	endif
next
consolewrite("Number of GPUs found: " & ubound($gpus) & "." & @crlf)

#cs
$adapterinfostruct=dllstructcreate("int iSize;int iAdapterIndex;char strUDID[256];int iBusNumber;int iDeviceNumber;int iFunctionNumber;int iVendorID;char strAdapterName[256];char strDisplayName[256];int iPresent;int iExist;char strDriverPath[256];char strDriverPathExt[256];char strPNPString[256];int iOSDisplayIndex")
$adapterinfosize=$numberofadapters*dllstructgetsize($adapterinfostruct)
$adapterinfoptr=ADL_Main_Memory_Alloc($adapterinfosize)
$temp=dllcall($dll,"int:cdecl","ADL_Adapter_AdapterInfo_Get","ptr",$adapterinfoptr,"int",$adapterinfosize)

dim $adapterinfo[$numberofadapters][15]
for $i=0 to $numberofadapters-1
	for $j=0 to ubound($adapterstruct,1)-1
		$adapterinfo[$i][$j]=__memoryread($adapterinfoptr+$i*dllstructgetsize($adapterinfostruct)+$adapterstruct[$j][2],$adapterstruct[$j][0])
	next
next
_arraydisplay($adapterinfo)
#ce

#cs
$adapterinfostructstrbase="int iSize;int iAdapterIndex;char strUDID[256];int iBusNumber;int iDeviceNumber;int iFunctionNumber;int iVendorID;char strAdapterName[256];char strDisplayName[256];int iPresent;int iExist;char strDriverPath[256];char strDriverPathExt[256];char strPNPString[256];int iOSDisplayIndex;"
$adapterinfostructstr=""
for $i=0 to $numberofadapters-1
	$adapterinfostructstr=$adapterinfostructstr & $adapterinfostructstrbase
next
$adapterinfostruct=dllstructcreate($adapterinfostructstr)
$temp=dllcall($dll,"int:cdecl","ADL_Adapter_AdapterInfo_Get","ptr",dllstructgetptr($adapterinfostruct),"int",dllstructgetsize($adapterinfostruct))

dim $adapterinfo[$numberofadapters][15]
for $i=0 to $numberofadapters-1
	for $j=0 to ubound($adapterstruct,1)-1
		$adapterinfo[$i][$j]=dllstructgetdata($adapterinfostruct,$i*15+$j+1)
	next
next
;~ _arraydisplay($adapterinfo)
#ce

$odperformancelevelsstructarray=""
for $i=0 to ubound($gpus)-1
	$odparameterrangestructstr="int iMin;int iMax;int iStep;"
	$odparametersstructstr="int iSize;int iNumberOfPerformanceLevels;int iActivityReportingSupported;int iDiscretePerformanceLevels;int iReserved;" & $odparameterrangestructstr & $odparameterrangestructstr & $odparameterrangestructstr
	$odparametersstruct=dllstructcreate($odparametersstructstr)
	dllstructsetdata($odparametersstruct,1,dllstructgetsize($odparametersstruct))
	$temp=dllcall($dll,"int:cdecl","ADL_Overdrive5_ODParameters_Get","int",$gpus[$i][0],"ptr",dllstructgetptr($odparametersstruct))
	$numberofperformancelevels=dllstructgetdata($odparametersstruct,2)
	
	$odperformancelevelstructstr="int iEngineClock;int iMemoryClock;int iVddc;"
	$odperformancelevelsstructstr="int iSize;int iReserved;"
	for $j=1 to $numberofperformancelevels
		$odperformancelevelsstructstr=$odperformancelevelsstructstr & $odperformancelevelstructstr
	next
	$odperformancelevelsstruct=dllstructcreate($odperformancelevelsstructstr)
	dllstructsetdata($odperformancelevelsstruct,1,dllstructgetsize($odperformancelevelsstruct))
	$temp=dllcall($dll,"int:cdecl","ADL_Overdrive5_ODPerformanceLevels_Get","int",$gpus[$i][0],"int",0,"ptr",dllstructgetptr($odperformancelevelsstruct))
	consolewrite("GPU #" & $gpus[$i][0] & " (ID " & $gpus[$i][1] & "): " & $numberofperformancelevels & " performance levels detected." & @crlf)
	for $j=1 to $numberofperformancelevels
		consolewrite(" Core: " & dllstructgetdata($odperformancelevelsstruct,3+($j-1)*3)/100 & " MHz. Memory: " & dllstructgetdata($odperformancelevelsstruct,4+($j-1)*3)/100 & " MHz. VDDC: " & dllstructgetdata($odperformancelevelsstruct,5+($j-1)*3)/1000 & " V." & @crlf)
	next
	consolewrite(" Temperature: " & temperature($dll,$gpus[$i][0]) & "C." & @crlf)
	$fan=getfanspeed($dll,$gpus[$i][0])
	consolewrite(" Fan speed: " & $fan[1] & " RPM (" & $fan[0] & "%)." & @crlf)
	_redim($odperformancelevelsstructarray,ubound($odperformancelevelsstructarray)+1,2)
	$odperformancelevelsstructarray[ubound($odperformancelevelsstructarray)-1][0]=$odperformancelevelsstruct
	$odperformancelevelsstructarray[ubound($odperformancelevelsstructarray)-1][1]=$numberofperformancelevels
next

if $cmdlineraw<>"" then
	consolewrite(@crlf)
	
	$gpuset=-1
	$coreset=-1
	$memoryset=-1
	$vddcset=-1
	$fanset=-1
	$default=false
	if stringleft($cmdlineraw,4)="gpu=" then
		for $i=1 to $cmdline[0]
			$split=stringsplit($cmdline[$i],"=",2)
			if ubound($split)=2 and number($split[1])=$split[1] then
				$value=number($split[1])
				switch stringlower($split[0])
					case "gpu"
						consolewrite("Configuring settings for GPU #" & $value & "." & @crlf)
						$gpuset=$value
					case "core"
						consolewrite("Setting core to " & $value & " MHz." & @crlf)
						$coreset=$value*100
					case "memory"
						consolewrite("Setting memory to " & $value & " MHz." & @crlf)
						$memoryset=$value*100
					case "vddc"
						consolewrite("Setting VDDC to " & $value & " V." & @crlf)
						$vddcset=$value*1000
					case "fan"
						consolewrite("Setting fan speed to " & $value & "%." & @crlf)
						$fanset=$value
					case else
						consolewrite($cmdline[$i] & " is an invalid argument, skipping." & @crlf)
				endswitch
			elseif $gpuset>-1 and $cmdline[$i]="default" then
				consolewrite("Resetting settings for GPU #" & $gpuset & ", ignoring all other arguments." & @crlf)
				$default=true
			else
				consolewrite($cmdline[$i] & " is an invalid argument, skipping." & @crlf)
			endif
		next
	else
		consolewrite("GPU number not specified!" & @crlf)
		quit()
	endif
	
	for $i=0 to ubound($gpus)-1
		if $gpus[$i][0]=$gpuset then
			if ($coreset>-1 or $memoryset>-1 or $vddcset>-1) and not $default then
				if $coreset>-1 then
					dllstructsetdata($odperformancelevelsstructarray[$i][0],3,$coreset)
					dllstructsetdata($odperformancelevelsstructarray[$i][0],6,$coreset)
					dllstructsetdata($odperformancelevelsstructarray[$i][0],9,$coreset)
				endif
				if $memoryset>-1 then
					dllstructsetdata($odperformancelevelsstructarray[$i][0],4,$memoryset)
					dllstructsetdata($odperformancelevelsstructarray[$i][0],7,$memoryset)
					dllstructsetdata($odperformancelevelsstructarray[$i][0],10,$memoryset)
				endif
				if $vddcset>-1 then
					dllstructsetdata($odperformancelevelsstructarray[$i][0],5,$vddcset)
					dllstructsetdata($odperformancelevelsstructarray[$i][0],8,$vddcset)
					dllstructsetdata($odperformancelevelsstructarray[$i][0],11,$vddcset)
				else
					dllstructsetdata($odperformancelevelsstructarray[$i][0],5,dllstructgetdata($odperformancelevelsstructarray[$i][0],11))
					dllstructsetdata($odperformancelevelsstructarray[$i][0],8,dllstructgetdata($odperformancelevelsstructarray[$i][0],11))
				endif
				$temp=dllcall($dll,"int:cdecl","ADL_Overdrive5_ODPerformanceLevels_Set","int",$gpus[$i][0],"ptr",dllstructgetptr($odperformancelevelsstructarray[$i][0]))
				if $temp[0]=0 then
					consolewrite("Clock/voltage changes committed successfully!" & @crlf)
				else
					consolewrite("Failed to commit clock/voltage changes. Error: " & $temp[0] & @crlf)
				endif
			endif
			if $fanset>-1 and not $default then
				$fanspeedstruct=dllstructcreate("int iSize;int iSpeedType;int iFanSpeed;int iFlags")
				dllstructsetdata($fanspeedstruct,1,dllstructgetsize($fanspeedstruct))
				dllstructsetdata($fanspeedstruct,2,1)
				dllstructsetdata($fanspeedstruct,3,$fanset)
				$temp=dllcall($dll,"int:cdecl","ADL_Overdrive5_FanSpeed_Set","int",$gpus[$i][0],"int",0,"ptr",dllstructgetptr($fanspeedstruct))
				if $temp[0]=0 then
					consolewrite("Fan speed change committed successfully!" & @crlf)
				else
					consolewrite("Failed to commit fan speed change. Error: " & $temp[0] & @crlf)
				endif
			endif
			if $default then
				$odparameterrangestructstr="int iMin;int iMax;int iStep;"
				$odparametersstructstr="int iSize;int iNumberOfPerformanceLevels;int iActivityReportingSupported;int iDiscretePerformanceLevels;int iReserved;" & $odparameterrangestructstr & $odparameterrangestructstr & $odparameterrangestructstr
				$odparametersstruct=dllstructcreate($odparametersstructstr)
				dllstructsetdata($odparametersstruct,1,dllstructgetsize($odparametersstruct))
				$temp=dllcall($dll,"int:cdecl","ADL_Overdrive5_ODParameters_Get","int",$gpus[$i][0],"ptr",dllstructgetptr($odparametersstruct))
				$numberofperformancelevels=dllstructgetdata($odparametersstruct,2)
				
				$odperformancelevelstructstr="int iEngineClock;int iMemoryClock;int iVddc;"
				$odperformancelevelsstructstr="int iSize;int iReserved;"
				for $j=1 to $numberofperformancelevels
					$odperformancelevelsstructstr=$odperformancelevelsstructstr & $odperformancelevelstructstr
				next
				$odperformancelevelsstruct=dllstructcreate($odperformancelevelsstructstr)
				dllstructsetdata($odperformancelevelsstruct,1,dllstructgetsize($odperformancelevelsstruct))
				$temp=dllcall($dll,"int:cdecl","ADL_Overdrive5_ODPerformanceLevels_Get","int",$gpus[$i][0],"int",1,"ptr",dllstructgetptr($odperformancelevelsstruct))
				
				$temp=dllcall($dll,"int:cdecl","ADL_Overdrive5_ODPerformanceLevels_Set","int",$gpus[$i][0],"ptr",dllstructgetptr($odperformancelevelsstruct))
				if $temp[0]=0 then
					consolewrite("Clock/voltage resetted successfully!" & @crlf)
				else
					consolewrite("Failed reset clock/voltage. Error: " & $temp[0] & @crlf)
				endif
				
				$temp=dllcall($dll,"int:cdecl","ADL_Overdrive5_FanSpeedToDefault_Set","int",$gpus[$i][0],"int",0)
				if $temp[0]=0 then
					consolewrite("Fan speed resetted successfully!" & @crlf)
				else
					consolewrite("Failed reset fan speed. Error: " & $temp[0] & @crlf)
				endif
			endif
			exitloop
		endif
	next
endif

;~ for $i=0 to ubound($gpus)-1
;~ 	consolewrite("GPU #" & $gpus[$i][0] & " (ID " & $gpus[$i][1] & "): " & $odperformancelevelsstructarray[$i][1] & " performance levels detected." & @crlf)
;~ 	for $j=1 to $odperformancelevelsstructarray[$i][1]
;~ 		consolewrite(" Core: " & dllstructgetdata($odperformancelevelsstructarray[$i][0],3+($j-1)*3)/100 & " MHz. Memory: " & dllstructgetdata($odperformancelevelsstructarray[$i][0],4+($j-1)*3)/100 & " MHz. VDDC: " & dllstructgetdata($odperformancelevelsstructarray[$i][0],5+($j-1)*3)/1000 & " V." & @crlf)
;~ 	next
;~ next

func quit()
	dllcallbackfree($malloc)
	dllclose($dll)
endfunc

func getfanspeed($dll,$adapter)
	$fanspeedstruct=dllstructcreate("int iSize;int iSpeedType;int iFanSpeed;int iFlags")
	dllstructsetdata($fanspeedstruct,1,dllstructgetsize($fanspeedstruct))
	dllstructsetdata($fanspeedstruct,2,1)
	$temp=dllcall($dll,"int:cdecl","ADL_Overdrive5_FanSpeed_Get","int",$adapter,"int",0,"ptr",dllstructgetptr($fanspeedstruct))
	$percent=dllstructgetdata($fanspeedstruct,3)
	dllstructsetdata($fanspeedstruct,2,2)
	$temp=dllcall($dll,"int:cdecl","ADL_Overdrive5_FanSpeed_Get","int",$adapter,"int",0,"ptr",dllstructgetptr($fanspeedstruct))
	$rpm=dllstructgetdata($fanspeedstruct,3)
	dim $fanspeed[2]=[$percent,$rpm]
	return $fanspeed
endfunc

func temperature($dll,$adapter)
	$temperaturestruct=dllstructcreate("int iSize;int iTemperature")
	dllstructsetdata($temperaturestruct,1,dllstructgetsize($temperaturestruct))
	$temp=dllcall($dll,"int:cdecl","ADL_Overdrive5_Temperature_Get","int",$adapter,"int",0,"ptr",dllstructgetptr($temperaturestruct))
	return dllstructgetdata($temperaturestruct,2)/1000
endfunc

func __memoryread($address,$type,$process=@autoitpid)
	$mem=_memoryopen($process)
	$data=_memoryread($address,$mem,$type)
	_memoryclose($mem)
	return $data
endfunc

func __memorywrite($address,$data,$type,$process=@autoitpid)
	$mem=_memoryopen($process)
	_memorywrite($address,$mem,$data,$type)
	_memoryclose($mem)
endfunc

func ADL_Main_Memory_Alloc($i)
	$mem=_memglobalalloc($i)
	return $mem
endfunc

func ADL_Main_Memory_Free()
	
endfunc

func _redim(byref $array,$size,$2d=0)
	if ubound($array)<1 then
		if $2d then
			dim $array[$size][$2d]
		else
			dim $array[$size]
		endif
	else
		if $2d then
			redim $array[$size][$2d]
		else
			redim $array[$size]
		endif
	endif
endfunc
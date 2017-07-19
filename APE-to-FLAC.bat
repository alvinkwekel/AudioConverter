:: Author: Alvin Kwekel (alvinkwekel@gmail.com)
:: Mod. date: 2013-05-16
:: Descr: Reads all .ape files recursively and converts them to FLAC
@ECHO OFF
SETLOCAL DisableDelayedExpansion
SET inputdir=%~f1
FOR /R "%inputdir%" %%i IN (*.ape) DO (
SETLOCAL EnableDelayedExpansion
	:: Invoke vbs script to get UUID
	FOR /F "tokens=*" %%j IN ('cscript //NoLogo uuid.vbs') DO SET vbsuuid=%%j
	SET uuid=!vbsuuid:{=!
	SET uuid=!uuid:}=!
	SET uuid=!uuid: =!
	:: Convert to flac
 	flac "%%~fi" -f --endian=big --sign=unsigned --channels=2 --bps=8 --sample-rate=44100
	ENDLOCAL
)
:: Author: Alvin Kwekel (alvinkwekel@gmail.com)
:: Mod. date: 2013-05-16
:: Descr: Reads all .ape and .flac files recursively and converts them to Apple Lossless
@ECHO OFF
SETLOCAL DisableDelayedExpansion
SET inputdir=%~f1
FOR /R "%inputdir%" %%i IN (*.ape,*.flac) DO (
SETLOCAL EnableDelayedExpansion
	:: Invoke vbs script to get UUID
	FOR /F "tokens=*" %%j IN ('cscript //NoLogo uuid.vbs') DO SET vbsuuid=%%j
	SET uuid=!vbsuuid:{=!
	SET uuid=!uuid:}=!
	SET uuid=!uuid: =!
	ffmpeg -i "%%~fi" -ab 196k -ac 2 -ar 48000 "!inputdir!\!uuid!.mp3"
	ENDLOCAL
)
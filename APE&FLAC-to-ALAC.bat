:: Author: Alvin Kwekel (alvinkwekel@gmail.com)
:: Mod. date: 2013-05-16
:: Descr: Reads all .ape and .flac files recursively and converts them to Apple Lossless
@ECHO OFF
SETLOCAL DisableDelayedExpansion
SET inputdir=%~f1
SET outputdir=%~f2
FOR /R "%inputdir%" %%i IN (*.ape,*.flac) DO (
SETLOCAL EnableDelayedExpansion
	:: Invoke vbs script to get UUID
	FOR /F "tokens=*" %%j IN ('cscript //NoLogo uuid.vbs') DO SET vbsuuid=%%j
	SET uuid=!vbsuuid:{=!
	SET uuid=!uuid:}=!
	SET uuid=!uuid: =!
	:: Export first piece of FLAC artwork only
	metaflac.exe --export-picture-to="!outputdir!\!uuid!.jpg" "%%~fi"
	:: Get FLAC disc tag
	FOR /F "tokens=*" %%f IN ('metaflac.exe --show-tag=DISCNUMBER "%%~fi"') DO SET disc=%%f
	SET disc=!disc:~-1!
	:: Convert to m4a
 	ffmpeg -i "%%~fi" -map 0:0 -acodec alac "!outputdir!\!uuid!.m4a"
	:: Set disc tag and artwork in m4a file. AtomicParsley creates a 'temp' files as output.
	AtomicParsley.exe "!outputdir!\!uuid!.m4a" --disk !disc! --artwork "!outputdir!\!uuid!.jpg"
	:: Remove original .m4a and .jpg, keeping only the 'temp' output file of AtomicParsley in the output dir.
	DEL "!outputdir!\!uuid!.m4a" "!outputdir!\!uuid!.jpg"
	ENDLOCAL
)
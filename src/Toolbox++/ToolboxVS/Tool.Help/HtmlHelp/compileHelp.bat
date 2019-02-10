@rem -------------------------------------------------------------------------
@rem
@rem Toolbox++: Microsoft chm-help generator
@rem
@rem compile chm file
@rem
@rem Mozilla Public License Version 2.0
@rem
@rem -------------------------------------------------------------------------

@if "%myDebugEcho%" == "" set myDebugEcho=off
@echo %myDebugEcho%
@rem echo on

@rem
@rem define (prefix) name for generated help files
@rem
set helpName=Toolbox++ChmHelp
set helpEnumPrefix=eChmHelpID

@rem
@rem other settings
@rem
set compDir=Debug

set mydir=%~dp0
set myDrive=%~d0

set compileFile=Help.hhp
set noWait=%~1

%myDrive%
cd %mydir%
set myError=0
goto main

@rem ----------------------------------------------------------------------------
@rem 
@rem  copy single file
@rem 
@rem ----------------------------------------------------------------------------
:copyOneFile
echo copy "%~1" "%~2"
     copy "%~1" "%~2" 1>nul
goto :EOF

@rem ----------------------------------------------------------------------------
@rem 
@rem  main
@rem 
@rem ----------------------------------------------------------------------------

:main
if not "%compileFile%" == "" goto compileit
set /p compileFile="Enter hhp filename: "


:compileIt
@echo.
@echo. Copy files to compile folder %compDir%...
rd /s /q "%compDir%"
del /q "%compDir%"
if not exist "%compDir%" mkdir "%compDir%"
xcopy helpfiles "%compDir%" /s /e

@rem 
@rem create help control file
@rem
set helpCtrlFile=%mydir%\%compDir%\Help.hhp

echo.[OPTIONS]> 									"%helpCtrlFile%"
echo.Compatibility=1.1 or later>>					"%helpCtrlFile%"
echo.Title=Toolbox Help Generator>>					"%helpCtrlFile%"
echo.Compiled file=%helpName%.chm>>					"%helpCtrlFile%"
echo.Contents file=__HelpTOC.txt>>					"%helpCtrlFile%"
echo.Index file=__HelpIndex.txt>>					"%helpCtrlFile%"
echo.Default topic=index.html>>						"%helpCtrlFile%"
echo.Error log file=%helpName%.log>>				"%helpCtrlFile%"
echo.Display compile progress=Yes>>					"%helpCtrlFile%"
echo.Full-text search=Yes>>							"%helpCtrlFile%"
echo.Language=0x409 English (United States)>>		"%helpCtrlFile%"
echo.Display compile notes=Yes>>					"%helpCtrlFile%"
echo.>>												"%helpCtrlFile%"
echo.[ALIAS]>>										"%helpCtrlFile%"
echo.#include %helpName%_compiledAliases.txt>>		"%helpCtrlFile%"
echo.>>												"%helpCtrlFile%"
echo.[MAP]>>										"%helpCtrlFile%"
echo.#include %helpName%_compiledMap.txt>>			"%helpCtrlFile%"
echo.>>												"%helpCtrlFile%"
echo.[FILES]>>										"%helpCtrlFile%"
echo.>>												"%helpCtrlFile%"
echo.[INFOTYPES]>>									"%helpCtrlFile%"
echo.>>												"%helpCtrlFile%"

rem for %%i in (Help.hhp) do call :copyOneFile "%%i" "%compDir%"

set fileBasename=%mydir%\%compDir%\%helpName%
cmd /c compileHelpHeaderFiles.bat noWait "%fileBasename%"
echo.
cd "%compDir%"

"C:\Program Files (x86)\HTML Help Workshop\hhc.exe" "%compileFile%"

if not ."%ERRORLEVEL%" == ."1" goto doWait
echo.
echo. NO ERROR occured.
echo.
if not "%noWait%" == "" goto finish

:doWait
echo.
echo. ERRORLEVEL is not 1:
echo. ERRORLEVEL=%ERRORLEVEL%
echo.
pause

:finish
cd..

@rem ----------------------------------------------------------------------------
@rem 
@rem EOF
@rem 
@rem ----------------------------------------------------------------------------

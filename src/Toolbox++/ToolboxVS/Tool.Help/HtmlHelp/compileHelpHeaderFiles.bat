@rem -------------------------------------------------------------------------
@rem
@rem Toolbox++: Microsoft chm-help generator
@rem
@rem compile header files
@rem
@rem Mozilla Public License Version 2.0
@rem
@rem -------------------------------------------------------------------------
@if "%myDebugEcho%" == "" set myDebugEcho=off
@echo %myDebugEcho%

set compDir=Debug

set prgname=%~0
set refDir=%mydir%\%compDir%
set mydir=%~dp0
set myDrive=%~d0

set noWait=%~1
set fileBasename=%~2
for /F "tokens=2" %%i in ('date /t') do set myDate=%%i
set myTime=%time%
set myFulltime=%myDate% %myTime%

if "%fileBasename%" == "" goto emptyBasename

if "%helpEnumPrefix%" == "" set set helpEnumPrefix=eChmHelpID

set tempfile=%fileBasename%.tmp
set counter=1000
set stepsize=10
set indexFile=%fileBasename%_compiledAliases.txt
set mapFile=%fileBasename%_compiledMap.txt
set headerFile=%fileBasename%HelpIDsInclude.h
set cppFile=%fileBasename%HelpIDsInclude.cpp
set cppFileChar=%fileBasename%HelpIDsIncludeChar.cpp
set IDIndexFile=%fileBasename%HelpIDsIndex.txt

%myDrive%
cd %mydir%
goto main

:emptyBasename
echo.
echo. ERROR: No file basename given.
echo.
pause
goto :EOF

@rem ----------------------------------------------------------------------------
@rem 
@rem prepare output files
@rem 
@rem ----------------------------------------------------------------------------
:prepareOutFiles
echo. > "%indexFile%"
echo. > "%mapFile%"

echo > "%headerFile%" //
echo >>"%headerFile%" // This file was created by %prgname%.
echo >>"%headerFile%" // %myFulltime%
echo >>"%headerFile%" //

echo > "%cppFile%" //
echo >>"%cppFile%" // This file was created by %prgname%.
echo >>"%cppFile%" // %myFulltime%
echo >>"%cppFile%" //

echo > "%cppFileChar%" //
echo >>"%cppFileChar%" // This file was created by %prgname%.
echo >>"%cppFileChar%" // %myFulltime%
echo >>"%cppFileChar%" //

echo.# > "%IDIndexFile%"
echo.# This file was created by %prgname%. >>"%IDIndexFile%"
echo.# %myFulltime% >>"%IDIndexFile%"
echo.# >> "%IDIndexFile%"

goto :EOF
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
@rem  make relative path
@rem 
@rem ----------------------------------------------------------------------------
:upperCaseFirst
set upperCaseFirstResult__=%~1
set all__=%~2
set first__=%all__:~0,1%
set rest__=%all__:~1,255%
call :upperCase first__ "%first__%
call :lowerCase rest__ "%rest__%
set %upperCaseFirstResult__%=%first__%%rest__%
set upperCaseFirstResult__=
set first__=
set rest__=
goto :EOF

:upperCase
set upperCaseResult__=%~1
set upperCaseWord__=%~2
for %%a in ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I"
        "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R"
        "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z" "-=_" ".=_") do (
call set upperCaseWord__=%%upperCaseWord__:%%~a%%
)
set %upperCaseResult__%=%upperCaseWord__%
rem echo %upperCaseResult__%
set upperCaseWord__=
set upperCaseResult__=
goto :EOF

:lowerCase
set lowerCaseResult__=%~1
set lowerCaseWord__=%~2
for %%a in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i"
        "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r"
        "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z" "-=_" ".=_") do (
call set lowerCaseWord__=%%lowerCaseWord__:%%~a%%
)
set %lowerCaseResult__%=%lowerCaseWord__%
rem echo %lowerCaseResult__%
set lowerCaseWord__=
set lowerCaseResult__=
goto :EOF

@rem ----------------------------------------------------------------------------
@rem 
@rem  make relative path
@rem 
@rem ----------------------------------------------------------------------------
:makeIDForFilename
set fullname__=%~1
rem echo %fullname__%
call :getStrLen fullnameLen__ "%fullname__%"
call :getStrLen refDirLen__ "%refDir%"
set /A delta = %fullnameLen__% - %refDirLen__%
rem echo %fullnameLen__% %refDirLen__% %delta%
call set basename__=%%fullname__:~%refDirLen__%,%delta%%%
rem echo %basename__%
set helpIDName__=%basename__:\=_%
rem echo %helpIDName__%
call :upperCaseFirst helpIDName__ "%helpIDName__%
rem echo %helpIDName__%
rem pause
rem set helpIDName__=%helpIDName__:.html=%
set helpIDName__=%helpIDName__:_html=%
echo.   %basename__%
echo htmlHelpID_%helpIDName__% =%basename__%     >>"%indexFile%"
echo #define htmlHelpID_%helpIDName__% %counter% >>"%mapFile%"
echo %helpIDName__% %counter% >>"%IDIndexFile%"
echo.    en%helpIDName__% = %counter%,           >>"%headerFile%"
echo.    {%helpEnumPrefix%::en%helpIDName__%, L"%helpIDName__%"}, >>"%cppFile%"
echo.    {%helpEnumPrefix%::en%helpIDName__%,  "%helpIDName__%"}, >>"%cppFileChar%"

set /A counter=%counter% + %stepsize%
rem pause
set fullnameLen__=
set refDirLen__=
set basename__=
set helpIDName__=
goto :EOF

@rem ----------------------------------------------------------------------------
@rem 
@rem get string length
@rem 
@rem ----------------------------------------------------------------------------
:getStrLen
set varname__=%~1
set string__=%~2
ECHO %string__%> "%tempfile%"
FOR %%? IN ("%tempfile%") DO ( SET /A strlength__=%%~z? - 2 )
rem set partname__=%fullname__:%mydir%=ID%
rem echo %strlength__%

del "%tempfile%"
set %varname__%=%strlength__%
set varname__=
set strlength__=
goto :EOF
@rem ----------------------------------------------------------------------------
@rem 
@rem  main
@rem 
@rem ----------------------------------------------------------------------------
:main
call :prepareOutFiles

for /R "%compDir%" %%i in (*.html) do call :makeIDForFilename %%i

echo index file:    %indexFile%
echo map file:      %mapFile%
echo header file:   %headerFile%
echo cpp file:      %cppFile%
echo ID index file: %IDIndexFile%

if not "%noWait%" == "" goto finish

:doWait
echo.
pause

:finish

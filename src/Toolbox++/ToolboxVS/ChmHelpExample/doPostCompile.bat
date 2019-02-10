@rem
@rem copy files
@rem
set prgName=%~0
set projectDir=%~1
echo %prgName% %projectDir%

set sourceDir=%projectDir%\..\Tool.Help\HtmlHelp\Debug
set goalDir=%projectDir%\Compiled
set baseName=Toolbox++ChmHelp

copy "%sourceDir%\%baseName%.chm"             "%goalDir%"
copy "%sourceDir%\%baseName%HelpIDsIndex.txt" "%goalDir%"



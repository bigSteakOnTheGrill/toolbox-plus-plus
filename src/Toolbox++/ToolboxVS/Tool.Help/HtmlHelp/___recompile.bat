@rem -------------------------------------------------------------------------
@rem
@rem Toolbox++: Microsoft chm-help generator
@rem
@rem Rebuilt complete Help
@rem
@rem Mozilla Public License Version 2.0
@rem
@rem -------------------------------------------------------------------------

set basename=help

:runAgain
call compileHelp.bat noWait

set /p answer=Run again? [Y/n] 
if /I "%answer%" == "" goto runAgain
if /I "%answer%" == "y" goto runAgain

@rem
@rem EOF
@rem

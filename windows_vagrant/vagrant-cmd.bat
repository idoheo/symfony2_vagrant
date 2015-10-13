@echo off
set vagrant_start=%cd%
%~d0
cd %~p0
cd ..
set vagrant_cmd=%*

:vagrant_start
cls
echo. Vagrant execution

WHERE vagrant.exe 1>NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 (
    echo ------------------------------------------------------------
	echo. Vagrant not installed.
    echo. Install Vagrant first from http://www.vagrantup.com
	goto vagrant_finish
)

if not exist .\Vagrantfile (
    echo ------------------------------------------------------------
    echo. Vagrantfile not found in %cd%
    goto vagrant_finish
)

echo.
echo ------------------------------------------------------------
echo Directory: %cd%
if not defined vagrant_cmd (
    set /p vagrant_cmd="Command:   vagrant "
) else (
    echo Command:   vagrant %vagrant_cmd%
)
echo ------------------------------------------------------------
set vagrant_continue=""
set /p vagrant_continue="Continue? (Y|N): "
echo.
echo.
if %vagrant_continue%==Y goto vagrant_continue
if %vagrant_continue%==y goto vagrant_continue
if %vagrant_continue%==N goto vagrant_abort
if %vagrant_continue%==n goto vagrant_abort
goto vagrant_start

:vagrant_continue
    vagrant %vagrant_cmd%
goto vagrant_finish

:vagrant_abort
    echo Vagrant command execution aborted
goto vagrant_finish

:vagrant_finish
    echo.
    echo ------------------------------------------------------------
	cd %vagrant_start%

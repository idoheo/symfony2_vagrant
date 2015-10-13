@echo off
set vagrant_start=%cd%
%~d0
cd %~p0
cd ..
set vagrant_cmd=%*

:vagrant_start
cls
echo. Vagrant shell

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

for /f "tokens=2" %%i in ('vagrant -v') do set vv=%%i

echo. Directory: %cd%
echo ------------------------------------------------------------
:vagrant_loop
echo.
set vagrant_cmd=
set /p vagrant_cmd="[vagrant %vv%]: "
echo.
if not defined vagrant_cmd (
  echo.
  echo. Type:
  echo.  - cls  - to clear screen
  echo.  - help - for help
  echo.  - bye  - to quit
  echo.  - exit - to quit
  goto vagrant_loop
) else if "%vagrant_cmd%"=="cls" (
  goto vagrant_cls
) else if "%vagrant_cmd%"=="bye" (
  goto vagrant_bye
) else if "%vagrant_cmd%"=="exit" (
  goto vagrant_bye
) else (
  goto vagrant_execute
)

:vagrant_cls
  cls
goto vagrant_loop

:vagrant_execute
  vagrant %vagrant_cmd%
goto vagrant_loop

:vagrant_bye
  echo.  Bye!
  goto vagrant_finish
  
:vagrant_finish
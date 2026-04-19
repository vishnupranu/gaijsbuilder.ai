@echo off
setlocal
set "SCRIPT=%~dp0gsbuilder-ai"
set "GITBASH=%ProgramFiles%\Git\bin\bash.exe"
if not exist "%GITBASH%" set "GITBASH=%ProgramFiles(x86)%\Git\bin\bash.exe"
if not exist "%GITBASH%" (
  echo GSBUILDER.AI: Install Git for Windows ^(bash.exe^) first.
  exit /b 1
)
"%GITBASH%" "%SCRIPT%" %*

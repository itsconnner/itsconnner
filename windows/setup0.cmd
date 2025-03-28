@REM SPDX-License-Identifier: GPL-3.0-or-later
@echo off

where pwsh >nul 2>nul
if %errorlevel% neq 0 (
	winget install --id Microsoft.PowerShell
)

where git >nul 2>nul
if %errorlevel% neq 0 (
	winget install --id Git.Git
)

pwsh -Command ^
     "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser;" ^
     "exit"

echo Core scripting functionality set up


@echo off
title 文件名字符替换
mode con cols=60 lines=20
::文件要是重名，会提示错误。
setlocal EnableDelayedExpansion & color 0a
:1
set a=
set b=
set c=
cls&echo.
set /p a= 请输入要被替换的字符:
cls&echo.
set /p b= 请输入替换“!a!”的字符，若要去掉“!a!”，请直接回车:
for /f "delims=" %%a in ('dir /b /a /a-d') do (
if "%%~fa" neq "%~0" (
set xz=%%~na
ren "%%~fa" "!xz:%a%=%b%!%%~xa" ))
cls&echo.&set /p c= 操作完成，输入 0 返回，输入其它任意字符退出
if "!c!"=="0" (goto 1) else (exit)
GOTO :EOF

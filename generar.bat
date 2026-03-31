@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

if not exist .venv goto :noinstall

echo.
echo  ========================================
echo     GENERA PPT USS
echo  ========================================
echo.
echo  Tus clases disponibles:
echo  ----------------------------------------

:: Listar archivos .yml en clases/
set count=0
for %%f in (clases\*.yml) do call :addfile "%%f" "%%~nf"

:: Incluir content.yml si existe
if exist content.yml call :addcontent

if !count! equ 0 goto :noclases

echo.
echo  ----------------------------------------
echo   0. Salir
echo.
set /p choice="  Elige un numero: "

if "%choice%"=="0" exit /b 0

set "selected=!file[%choice%]!"
if not defined selected goto :invalid

echo.
echo  Generando desde: !selected!
echo.

.venv\Scripts\python engine.py run "!selected!"
if %errorlevel% neq 0 goto :errgener

echo.
echo  Presentacion generada! Abriendo carpeta output...
echo.
start output
pause
exit /b 0

:addfile
set /a count+=1
set "file[!count!]=%~1"
echo   !count!. %~2
goto :eof

:addcontent
set /a count+=1
set "file[!count!]=content.yml"
echo   !count!. content
goto :eof

:noinstall
echo [ERROR] Primero ejecuta instalar.bat
pause
exit /b 1

:noclases
echo.
echo   No hay archivos .yml en la carpeta clases
echo   Copia _plantilla.yml y renombralo para empezar.
pause
exit /b 1

:invalid
echo.
echo  [ERROR] Opcion no valida.
pause
exit /b 1

:errgener
echo.
echo  [ERROR] Hubo un problema al generar la presentacion.
pause
exit /b 1

@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

if not exist .venv (
    echo [ERROR] Primero ejecuta instalar.bat
    pause
    exit /b 1
)

echo.
echo  ========================================
echo     GENERA PPT USS
echo  ========================================
echo.
echo  Tus clases disponibles:
echo  ----------------------------------------

:: Listar archivos .yml en clases/ (excluyendo _plantilla.yml)
set count=0
for %%f in (clases\*.yml) do (
    set /a count+=1
    set "file[!count!]=%%f"
    set "name=%%~nf"
    echo   !count!. !name!
)

:: También incluir content.yml de la raíz si existe
if exist content.yml (
    set /a count+=1
    set "file[!count!]=content.yml"
    echo   !count!. content ^(raiz^)
)

if !count! equ 0 (
    echo.
    echo   No hay archivos .yml en la carpeta "clases/"
    echo   Copia _plantilla.yml y renombralo para empezar.
    pause
    exit /b 1
)

echo.
echo  ----------------------------------------
echo   0. Salir
echo.
set /p choice="  Elige un numero: "

if "%choice%"=="0" exit /b 0

:: Validar elección
if not defined file[%choice%] (
    echo.
    echo  [ERROR] Opcion no valida.
    pause
    exit /b 1
)

set "selected=!file[%choice%]!"
echo.
echo  Generando desde: %selected%
echo.

.venv\Scripts\python engine.py run "%selected%"

if %errorlevel% neq 0 (
    echo.
    echo  [ERROR] Hubo un problema al generar la presentacion.
    pause
    exit /b 1
)

echo.
echo  [OK] Presentacion generada! Abriendo carpeta output...
echo.
start output
pause

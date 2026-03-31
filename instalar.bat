@echo off
chcp 65001 >nul

echo ========================================
echo   Instalando Genera PPT USS
echo ========================================
echo.

:: Verificar si Python esta instalado
python --version >nul 2>&1
if %errorlevel% neq 0 goto :nopython

echo [OK] Python encontrado
echo.

:: Crear entorno virtual
echo Creando entorno virtual...
python -m venv .venv
if %errorlevel% neq 0 goto :errvenv

echo [OK] Entorno virtual creado
echo.

:: Instalar dependencias
echo Instalando dependencias...
.venv\Scripts\pip install -r requirements.txt
if %errorlevel% neq 0 goto :errdeps

echo.
echo ========================================
echo   Instalacion completada!
echo   Ahora edita tu archivo en clases/
echo   y ejecuta generar.bat
echo ========================================
pause
exit /b 0

:nopython
echo.
echo [ERROR] Python no esta instalado.
echo Descargalo de https://www.python.org/downloads/
echo IMPORTANTE: Marca la casilla "Add Python to PATH" al instalar.
pause
exit /b 1

:errvenv
echo.
echo [ERROR] No se pudo crear el entorno virtual.
pause
exit /b 1

:errdeps
echo.
echo [ERROR] No se pudieron instalar las dependencias.
pause
exit /b 1

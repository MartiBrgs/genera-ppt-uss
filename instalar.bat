@echo off
python --version >nul 2>&1
if %errorlevel% neq 0 goto :nopython
python -m venv .venv
.venv\Scripts\pip install -r requirements.txt
echo.
echo Instalacion completada! Ejecuta generar.bat
pause
exit /b 0

:nopython
echo Python no esta instalado. Descargalo de https://www.python.org/downloads/
echo Marca la casilla "Add Python to PATH" al instalar.
pause
exit /b 1

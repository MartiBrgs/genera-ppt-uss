@echo off
chcp 65001 >nul
echo ========================================
echo   Generando presentación...
echo ========================================
echo.

if not exist .venv (
    echo [ERROR] Primero ejecuta instalar.bat
    pause
    exit /b 1
)

.venv\Scripts\python engine.py run content.yml

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Hubo un problema al generar la presentación.
    pause
    exit /b 1
)

echo.
echo [OK] Presentación generada! Revisa la carpeta "output"
echo.

:: Abrir la carpeta output
start output
pause

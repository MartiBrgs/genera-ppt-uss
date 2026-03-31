@echo off
chcp 65001 >nul
echo ========================================
echo   Instalando Genera PPT USS
echo ========================================
echo.

:: Verificar si Python está instalado
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python no está instalado.
    echo Descárgalo de https://www.python.org/downloads/
    echo IMPORTANTE: Marca la casilla "Add Python to PATH" al instalar.
    pause
    exit /b 1
)

echo [OK] Python encontrado
echo.

:: Crear entorno virtual
echo Creando entorno virtual...
python -m venv .venv
if %errorlevel% neq 0 (
    echo [ERROR] No se pudo crear el entorno virtual.
    pause
    exit /b 1
)

echo [OK] Entorno virtual creado
echo.

:: Instalar dependencias
echo Instalando dependencias...
.venv\Scripts\pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [ERROR] No se pudieron instalar las dependencias.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Instalación completada!
echo   Ahora edita content.yml con tu contenido
echo   y ejecuta generar.bat
echo ========================================
pause

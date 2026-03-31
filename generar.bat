@echo off
if not exist .venv goto :noinstall
.venv\Scripts\streamlit run app.py
exit /b 0

:noinstall
echo Primero ejecuta instalar.bat
pause
exit /b 1

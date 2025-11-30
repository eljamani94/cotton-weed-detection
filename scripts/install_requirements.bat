@echo off
REM Installation script for Windows

echo 🚀 Installing Cotton Weed Detection Project Requirements
echo ========================================================

REM Check Python version
python --version
if errorlevel 1 (
    echo ❌ Python not found! Please install Python 3.8+ first.
    pause
    exit /b 1
)

REM Create virtual environment
echo 📁 Creating virtual environment...
python -m venv cotton_weed

REM Activate virtual environment
echo ✅ Activating virtual environment...
call cotton_weed\Scripts\activate.bat

REM Upgrade pip
echo ⬆️  Upgrading pip...
python -m pip install --upgrade pip

REM Install requirements
echo 📥 Installing Python packages...
pip install -r requirements.txt

echo.
echo ✅ Installation complete!
echo.
echo To activate the virtual environment, run:
echo   cotton_weed\Scripts\activate.bat
echo.
echo To run the API:
echo   cd api ^&^& uvicorn main:app --reload --port 8000
echo.
echo To run the Streamlit app:
echo   streamlit run app\main.py --server.port 8501
echo.
pause


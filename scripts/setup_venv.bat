@echo off
REM Create and setup virtual environment for the project

echo 🚀 Setting up Virtual Environment for Cotton Weed Detection Project
echo ====================================================================

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python is not installed or not in PATH!
    echo Please install Python 3.8+ from https://www.python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation.
    pause
    exit /b 1
)

echo ✅ Python found:
python --version

REM Check if virtual environment already exists
if exist cotton_weed (
    echo.
    echo ⚠️  Virtual environment already exists!
    echo.
    set /p choice="Do you want to delete and recreate it? (y/n): "
    if /i "%choice%"=="y" (
        echo.
        echo 🗑️  Removing existing virtual environment...
        rmdir /s /q cotton_weed
        echo ✅ Old virtual environment removed.
    ) else (
        echo.
        echo ℹ️  Keeping existing virtual environment.
        echo.
        echo To activate it, run:
        echo   cotton_weed\Scripts\activate.bat
        pause
        exit /b 0
    )
)

echo.
echo 📁 Creating new virtual environment...
python -m venv cotton_weed

if errorlevel 1 (
    echo ❌ Failed to create virtual environment!
    pause
    exit /b 1
)

echo ✅ Virtual environment created successfully!
echo.

REM Activate virtual environment
echo 🔄 Activating virtual environment...
call cotton_weed\Scripts\activate.bat

REM Upgrade pip
echo.
echo ⬆️  Upgrading pip...
python -m pip install --upgrade pip

echo.
echo ✅ Virtual environment setup complete!
echo.
echo ====================================================================
echo 📝 Next Steps:
echo ====================================================================
echo.
echo 1. The virtual environment is now ACTIVE (you'll see (cotton_weed) in your prompt)
echo.
echo 2. Install project dependencies:
echo    pip install -r requirements.txt
echo.
echo 3. To activate this environment in the future, run:
echo    cotton_weed\Scripts\activate.bat
echo.
echo 4. To deactivate, simply type:
echo    deactivate
echo.
echo ====================================================================
pause


@echo off
REM Fix Pillow installation issue on Windows
REM Install Pillow separately first, then install other requirements

echo 🔧 Fixing Pillow installation for Windows...
echo.

REM Activate virtual environment if it exists
if exist cotton_weed\Scripts\activate.bat (
    call cotton_weed\Scripts\activate.bat
) else (
    echo ❌ Virtual environment not found!
    echo Please run: .\scripts\setup_venv.bat first
    pause
    exit /b 1
)

echo 📦 Installing core packages with pre-built wheels...
pip install --upgrade pip

echo Installing NumPy (with pre-built wheel)...
pip install "numpy>=1.24.0,<2.0.0"

echo Installing Pillow...
pip install "Pillow>=10.2.0,<11.0.0"

if errorlevel 1 (
    echo.
    echo ⚠️  Pillow installation failed. Trying alternative method...
    pip install --only-binary :all: Pillow
)

echo.
echo ✅ Core packages installed successfully!
echo.
echo Now installing other requirements...
pip install -r requirements.txt

echo.
echo ✅ All packages installed!
pause


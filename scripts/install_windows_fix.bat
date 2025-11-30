@echo off
REM Complete installation fix for Windows
REM Installs packages with pre-built wheels to avoid compilation issues

echo 🔧 Installing packages with Windows-compatible versions...
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

echo 📦 Upgrading pip...
pip install --upgrade pip

echo.
echo 📦 Installing NumPy (pre-built wheel, no compilation needed)...
pip install "numpy>=1.24.0,<2.0.0"

echo.
echo 📦 Installing Pillow (pre-built wheel)...
pip install "Pillow>=10.2.0,<11.0.0"

echo.
echo 📦 Installing other core packages...
pip install "opencv-python>=4.8.0"
pip install "pandas>=1.4.0,<3.0.0"

echo.
echo 📦 Installing web framework packages...
pip install "streamlit>=1.28.0"
pip install "fastapi>=0.104.0"
pip install "uvicorn[standard]>=0.24.0"
pip install "python-multipart>=0.0.6"

echo.
echo 📦 Installing deep learning packages (this may take a while)...
pip install "torch>=2.0.0" --index-url https://download.pytorch.org/whl/cpu
pip install "torchvision>=0.15.0" --index-url https://download.pytorch.org/whl/cpu

echo.
echo 📦 Installing database and utility packages...
pip install "sqlalchemy>=2.0.0"
pip install "aiosqlite>=0.19.0"
pip install "pydantic>=2.0.0"
pip install "python-dotenv>=1.0.0"
pip install "aiofiles>=23.0.0"

echo.
echo 📦 Installing Google Cloud packages (optional, for deployment)...
pip install "google-cloud-storage>=2.10.0"
pip install "google-cloud-compute>=1.10.0"

echo.
echo ✅ All packages installed successfully!
echo.
echo You can now:
echo   1. Add your model to the models/ folder
echo   2. Run: .\scripts\start_api.bat (in one terminal)
echo   3. Run: .\scripts\start_app.bat (in another terminal)
echo.
pause


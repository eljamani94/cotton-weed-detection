@echo off
REM Start the FastAPI backend

echo 🚀 Starting Cotton Weed Detection API...
echo.

REM Activate virtual environment if it exists
if exist cotton_weed\Scripts\activate.bat (
    call cotton_weed\Scripts\activate.bat
)

REM Start API
uvicorn api.main:app --reload --host 0.0.0.0 --port 8000

pause


@echo off
REM Start the Streamlit frontend

echo 🚀 Starting Cotton Weed Detection App...
echo.

REM Activate virtual environment if it exists
if exist cotton_weed\Scripts\activate.bat (
    call cotton_weed\Scripts\activate.bat
)

REM Start Streamlit
streamlit run app\main.py --server.port 8501

pause


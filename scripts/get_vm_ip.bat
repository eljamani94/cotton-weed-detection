@echo off
REM Get current VM IP address

echo Getting VM IP address...
echo.

for /f "tokens=*" %%i in ('gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format="get(networkInterfaces[0].accessConfigs[0].natIP)"') do (
    echo ========================================
    echo Your VM IP: %%i
    echo.
    echo Access your app at:
    echo   Streamlit: http://%%i:8501
    echo   API Docs:  http://%%i:8000/docs
    echo ========================================
)

pause


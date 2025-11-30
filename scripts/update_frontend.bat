@echo off
REM Script to update frontend on cloud after local edits

echo ========================================
echo Updating Frontend on Google Cloud
echo ========================================
echo.

echo [1/4] Building new Docker image...
docker build -f docker/Dockerfile.app -t gcr.io/cotton-weed-detection-app/app:latest .

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo [2/4] Pushing image to Google Cloud...
docker push gcr.io/cotton-weed-detection-app/app:latest

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Push failed!
    pause
    exit /b 1
)

echo.
echo [3/4] Updating VM...
echo SSH into VM and run:
echo   docker pull gcr.io/cotton-weed-detection-app/app:latest
echo   docker-compose down
echo   docker-compose up -d
echo.

echo [4/4] Or run this command:
echo gcloud compute ssh cotton-weed-vm --zone=us-central1-a --command="docker pull gcr.io/cotton-weed-detection-app/app:latest && cd ~ && docker-compose down && docker-compose up -d"
echo.

pause


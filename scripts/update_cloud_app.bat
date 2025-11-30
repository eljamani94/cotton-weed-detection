@echo off
REM Script to update the app on cloud VM with local changes
REM This will build, push, and deploy the updated app

echo ====================================
echo Updating App on Cloud VM
echo ====================================
echo.

REM Check if gcloud is available
where gcloud >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: gcloud CLI not found!
    echo Please install Google Cloud SDK first.
    pause
    exit /b 1
)

REM Get project ID
echo Getting project ID...
for /f "tokens=*" %%i in ('gcloud config get-value project') do set PROJECT_ID=%%i
echo Project ID: %PROJECT_ID%
echo.

REM Pull existing image first to use as cache (makes subsequent builds faster)
echo Step 1: Pulling existing image for cache...
docker pull gcr.io/%PROJECT_ID%/app:latest 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Existing image not found - first time build (this is normal)
)

REM Build the new app image with local changes (using cache)
echo.
echo Step 2: Building new app image with your local changes...
echo This should be fast if cache works - only the changed layer rebuilds...
docker build --cache-from gcr.io/%PROJECT_ID%/app:latest -f docker/Dockerfile.app -t gcr.io/%PROJECT_ID%/app:latest .

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Docker build failed!
    pause
    exit /b 1
)

echo.
echo Build successful!
echo.
echo Note: Most layers should be CACHED - only your changed files rebuild.
echo.

REM Push the image to Google Container Registry
echo Step 3: Pushing image to Google Container Registry...
echo This should only upload changed layers (~50-200MB) if cache worked correctly...
echo If it uploads 4GB, Docker cache isn't working - this is slower but still works.
docker push gcr.io/%PROJECT_ID%/app:latest

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Docker push failed!
    echo Make sure you're authenticated: gcloud auth configure-docker
    pause
    exit /b 1
)

echo.
echo Push successful!
echo.

REM SSH into VM and update
echo.
echo Step 4: Updating container on VM...
echo You'll need to SSH into the VM and run these commands:
echo.
echo   docker pull gcr.io/%PROJECT_ID%/app:latest
echo   docker-compose restart app
echo.
echo Or run this automated command:
echo   gcloud compute ssh cotton-weed-vm --zone=us-central1-a --command="docker pull gcr.io/%PROJECT_ID%/app:latest && docker-compose restart app"
echo.
echo Would you like to update the VM automatically now? (Y/N)
set /p UPDATE_VM="> "

if /i "%UPDATE_VM%"=="Y" (
    echo.
    echo Updating VM container...
    gcloud compute ssh cotton-weed-vm --zone=us-central1-a --command="cd ~ && docker pull gcr.io/%PROJECT_ID%/app:latest && docker-compose restart app"
    
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo WARNING: Automatic update may have failed.
        echo Please SSH into the VM manually and run:
        echo   docker pull gcr.io/%PROJECT_ID%/app:latest
        echo   docker-compose restart app
    ) else (
        echo.
        echo Success! Your app has been updated on the cloud VM!
        echo The new version should be live now.
    )
) else (
    echo.
    echo To update manually, SSH into the VM and run:
    echo   gcloud compute ssh cotton-weed-vm --zone=us-central1-a
    echo   docker pull gcr.io/%PROJECT_ID%/app:latest
    echo   docker-compose restart app
)

echo.
echo ====================================
echo Done!
echo ====================================
pause


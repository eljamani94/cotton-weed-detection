@echo off
REM Quick deployment script for Windows
REM This copies deployment scripts to VM and provides instructions

echo ========================================
echo Streamlit App Deployment Helper
echo ========================================
echo.

echo Step 1: Copying deployment scripts to VM...
gcloud compute scp scripts/deploy_streamlit_vm.sh cotton-weed-vm:~ --zone=us-central1-a
if %errorlevel% neq 0 (
    echo ERROR: Failed to copy deploy_streamlit_vm.sh
    pause
    exit /b 1
)

gcloud compute scp scripts/check_deployment.sh cotton-weed-vm:~ --zone=us-central1-a
if %errorlevel% neq 0 (
    echo ERROR: Failed to copy check_deployment.sh
    pause
    exit /b 1
)

gcloud compute scp scripts/setup_firewall.sh cotton-weed-vm:~ --zone=us-central1-a
if %errorlevel% neq 0 (
    echo ERROR: Failed to copy setup_firewall.sh
    pause
    exit /b 1
)

echo.
echo Step 2: Copying models folder (if needed)...
echo Checking if models folder exists...
if exist "models\yolov8n_best_model.pt" (
    echo Copying models folder to VM...
    gcloud compute scp --recurse models\ cotton-weed-vm:~/models/ --zone=us-central1-a
    if %errorlevel% neq 0 (
        echo WARNING: Failed to copy models folder
    ) else (
        echo Models folder copied successfully
    )
) else (
    echo WARNING: Models folder not found. Make sure to copy it manually.
)

echo.
echo ========================================
echo Scripts copied successfully!
echo ========================================
echo.
echo Next steps:
echo 1. SSH into the VM:
echo    gcloud compute ssh cotton-weed-vm --zone=us-central1-a
echo.
echo 2. Inside the VM, run:
echo    chmod +x deploy_streamlit_vm.sh check_deployment.sh setup_firewall.sh
echo    ./setup_firewall.sh
echo    ./deploy_streamlit_vm.sh
echo.
echo 3. Verify deployment:
echo    ./check_deployment.sh
echo.
echo ========================================
pause


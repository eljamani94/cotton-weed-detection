@echo off
REM Quick script to start cloud deployment for demo

echo ========================================
echo Starting Cotton Weed Detection - Cloud
echo ========================================
echo.

echo [1/4] Starting VM instance...
gcloud compute instances start cotton-weed-vm --zone=us-central1-a

echo.
echo [2/4] Waiting for VM to boot (30 seconds)...
timeout /t 30 /nobreak >nul

echo.
echo [3/4] Getting VM IP address...
for /f "tokens=*" %%i in ('gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format="get(networkInterfaces[0].accessConfigs[0].natIP)"') do set VM_IP=%%i

echo.
echo ========================================
echo VM is starting!
echo.
echo Your VM IP: %VM_IP%
echo.
echo Next steps:
echo 1. SSH into VM: gcloud compute ssh cotton-weed-vm --zone=us-central1-a
echo 2. Run: alias docker-compose='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:$PWD" -w "$PWD" docker/compose:latest'
echo 3. Run: cd ~ && docker-compose up -d
echo 4. Access: http://%VM_IP%:8501
echo ========================================
echo.

pause


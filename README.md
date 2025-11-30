# Cotton Weed Detection - MLOps Web Application

A professional MLOps web application for detecting cotton weeds using deep learning. The app works on both mobile phones (with camera) and laptops (without camera), with real-time synchronization between devices.

## 🏗️ Architecture

- **Frontend**: Streamlit web application
- **Backend**: FastAPI REST API
- **Containerization**: Docker
- **Deployment**: Google Cloud Platform (Compute Engine)

## 📁 Project Structure

```
cotton_weed_project/
├── app/                    # Streamlit frontend
│   ├── main.py            # Main Streamlit app
│   └── utils.py           # Helper functions
├── api/                    # FastAPI backend
│   ├── main.py            # FastAPI application
│   ├── model_loader.py    # Model loading logic
│   └── predictor.py       # Prediction logic
├── models/                 # Trained model files (place your model here)
├── docker/                 # Docker configurations
│   ├── Dockerfile.api     # API container
│   └── Dockerfile.app     # Streamlit container
├── scripts/               # Deployment scripts
├── requirements.txt        # Python dependencies
└── docker-compose.yml      # Docker orchestration
```

## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- Docker (optional, for containerization)
- Google Cloud account with $300 free trial

### Local Development

1. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Place your trained model in the `models/` folder**

3. **Run the API:**
   ```bash
   cd api
   uvicorn main:app --reload --port 8000
   ```

4. **Run the Streamlit app:**
   ```bash
   streamlit run app/main.py --server.port 8501
   ```

5. **Access the app:**
   - Open browser: `http://localhost:8501`
   - API docs: `http://localhost:8000/docs`

## 📱 Features

- **Mobile Support**: Camera access for real-time weed detection
- **Laptop Support**: Image upload for weed detection
- **Real-time Sync**: Predictions sync between devices
- **Bounding Box Visualization**: Visual detection results with class labels

## 🐳 Docker Deployment

```bash
docker-compose up --build
```

## ☁️ Deployment Options

### Option 1: Streamlit Cloud (Recommended) 🌟

Deploy your Streamlit frontend to Streamlit Cloud for a `*.streamlit.app` URL!

**Quick start:**
1. Push code to GitHub (see `GITHUB_SETUP.md`)
2. Deploy to Streamlit Cloud (see `QUICK_DEPLOY_STREAMLIT_CLOUD.md`)
3. Keep FastAPI backend on VM

**📖 Guides:**
- **Quick Deploy:** `QUICK_DEPLOY_STREAMLIT_CLOUD.md` - 3-step deployment
- **GitHub Setup:** `GITHUB_SETUP.md` - Push code to GitHub
- **Streamlit Cloud:** `STREAMLIT_CLOUD_DEPLOYMENT.md` - Detailed deployment guide

### Option 2: Deploy on VM

**Deploy both frontend and backend on Google Cloud VM:**

1. **Copy scripts to VM:**
   ```powershell
   .\scripts\deploy_to_vm.bat
   ```

2. **SSH into VM:**
   ```powershell
   gcloud compute ssh cotton-weed-vm --zone=us-central1-a
   ```

3. **Deploy:**
   ```bash
   chmod +x *.sh
   ./setup_firewall.sh
   ./deploy_streamlit_vm.sh
   ```

4. **Verify:**
   ```bash
   ./check_deployment.sh
   ```

**📖 See `STREAMLIT_DEPLOYMENT.md` for complete VM deployment guide.**

**📖 See `GCP_DEPLOYMENT_STEPS.md` for detailed GCP setup instructions.**

## 📚 Workflow Guides

- **Streamlit Deployment:** See `STREAMLIT_DEPLOYMENT.md` for deploying Streamlit app on VM
- **Quick Start:** See `QUICK_START.md` for fastest way to run locally or cloud
- **Complete Workflow:** See `COMPLETE_WORKFLOW.md` for detailed instructions on running after restarting laptop or stopping VM
- **Deployment Scripts:** See `DEPLOYMENT_SCRIPTS_README.md` for script documentation
- **Cost Breakdown:** See `COST_BREAKDOWN.md` for pricing information

## 📝 Notes

- Make sure your model file is in the correct format
- Update model loading code in `api/model_loader.py` based on your model type
- Configure environment variables for production deployment


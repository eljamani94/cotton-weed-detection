# FieldVision (Cotton Weed Detection System)

<div align="center">

![Python](https://img.shields.io/badge/python-3.9+-blue.svg)
![Streamlit](https://img.shields.io/badge/streamlit-1.28+-red.svg)
![FastAPI](https://img.shields.io/badge/fastapi-0.104+-green.svg)
![PyTorch](https://img.shields.io/badge/pytorch-2.0+-orange.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

**A production-ready MLOps web application for automated cotton weed detection using deep learning and computer vision**

[Features](#-features) • [Quick Start](#-quick-start) • [Documentation](#-documentation) • [Deployment](#-cloud-deployment) • [API Reference](#-api-reference)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Quick Start](#-quick-start)
- [Installation](#-installation)
- [Usage](#-usage)
- [API Reference](#-api-reference)
- [Model Information](#-model-information)
- [Docker Deployment](#-docker-deployment)
- [Cloud Deployment](#-cloud-deployment)
- [Configuration](#-configuration)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Overview

The FieldVision Cotton Weed Detection System is an end-to-end MLOps application that uses YOLOv8 object detection to identify and classify weeds in cotton field images. The system provides a user-friendly web interface for farmers and agricultural researchers to upload field images and receive instant weed detection results with visual annotations.

**Key Capabilities:**
- Real-time weed detection in cotton field images
- Multi-class weed classification (Carpetweed, Morning Glory, Palmer Amaranth)
- Visual bounding box annotations with confidence scores
- RESTful API for integration with other systems
- Cloud-ready deployment architecture

**Live Demo:** [View the FieldVision App](https://fieldvision.streamlit.app/)

---

## ✨ Features

### Core Functionality
- 🎯 **Real-time Detection**: Instant weed identification in uploaded images
- 📊 **Multi-class Classification**: Detects 3 different weed species
- 🎨 **Visual Annotations**: Bounding boxes with color-coded class labels
- 📈 **Confidence Scores**: Displays detection confidence for each weed
- 📱 **Cross-platform**: Works on desktop and mobile devices
- 🔄 **RESTful API**: Scalable backend architecture for integration

### Technical Features
- ☁️ **Cloud Deployed**: Frontend on Streamlit Cloud, backend on Google Cloud
- 🐳 **Containerized**: Docker support for easy deployment
- 🔒 **Production Ready**: Health checks, error handling, and logging
- 📦 **Modular Design**: Separated frontend and backend for scalability
- 🚀 **Auto-scaling**: Backend can scale independently based on load

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        User Interface                         │
│                    (Streamlit Frontend)                      │
│                  https://app.streamlit.app                   │
└───────────────────────────┬─────────────────────────────────┘
                             │ HTTP Requests
                             │ (Image Upload)
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                      FastAPI Backend                          │
│                   (Google Cloud VM)                           │
│                    http://vm-ip:8000                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   /predict    │  │   /health    │  │    /docs     │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└───────────────────────────┬─────────────────────────────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   YOLOv8 Model  │
                    │   (YOLOv8n)     │
                    │                 │
                    │  - Carpetweed   │
                    │  - Morning Glory│
                    │  - Palmer       │
                    │    Amaranth     │
                    └─────────────────┘
```

---

## 🛠️ Tech Stack

### Frontend
- **Streamlit** - Web application framework
- **Pillow** - Image processing
- **Requests** - HTTP client

### Backend
- **FastAPI** - Modern Python web framework
- **PyTorch** - Deep learning framework
- **Ultralytics YOLOv8** - Object detection model
- **SQLAlchemy** - Database ORM
- **SQLite** - Lightweight database

### Infrastructure
- **Docker** - Containerization
- **Docker Compose** - Container orchestration
- **Google Cloud Platform** - Cloud infrastructure
- **Streamlit Cloud** - Frontend hosting

---

## 📁 Project Structure

```
cotton_weed_project/
├── app/                          # Streamlit frontend
│   ├── main.py                  # Main Streamlit application
│   ├── utils.py                 # Utility functions
│   └── assets/                  # Static assets (images, CSS)
│       └── background.jpg       # Background image
│
├── api/                          # FastAPI backend
│   ├── main.py                  # API endpoints and routes
│   ├── model_loader.py          # Model loading and initialization
│   ├── predictor.py             # Inference logic
│   ├── database.py              # Database operations
│   └── __init__.py
│
├── models/                       # Trained models
│   └── yolov8n_best_model.pt    # YOLOv8 trained model
│
├── docker/                       # Docker configurations
│   ├── Dockerfile.api           # API container definition
│   └── Dockerfile.app           # Streamlit app container
│
├── .streamlit/                   # Streamlit configuration
│   └── config.toml              # Streamlit settings
│
├── requirements.txt             # Python dependencies
├── docker-compose.yml           # Docker Compose configuration
└── README.md                     # This file
```

---

## 🚀 Quick Start

### Prerequisites

- Python 3.9 or higher
- pip package manager
- Docker (optional, for containerized deployment)
- Trained YOLOv8 model file (`.pt` format)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/cotton-weed-detection.git
   cd cotton-weed-detection
   ```

2. **Create virtual environment** (recommended)
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Place your model**
   - Copy your trained YOLOv8 model (`.pt` file) to the `models/` directory
   - Ensure the model file is named appropriately (e.g., `yolov8n_best_model.pt`)

---

## 💻 Usage

### Local Development

#### Start the Backend API

```bash
# From project root
uvicorn api.main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at:
- **API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/health

#### Start the Frontend

In a new terminal:

```bash
streamlit run app/main.py --server.port 8501
```

The Streamlit app will be available at:
- **Frontend**: http://localhost:8501

### Using the Application

1. **Open the Streamlit app** in your browser (http://localhost:8501)
2. **Upload an image** of a cotton field using the "Detect weeds" button
3. **View results** with bounding boxes, class labels, and confidence scores
4. **Analyze detections** in the summary section below the image

---

## 📡 API Reference

### Endpoints

#### `GET /health`
Health check endpoint to verify API status.

**Response:**
```json
{
  "status": "healthy",
  "model_loaded": true
}
```

#### `POST /predict`
Upload an image and receive weed detection predictions.

**Request:**
- Method: `POST`
- Content-Type: `multipart/form-data`
- Body: Image file (JPG, PNG, etc.)

**Response:**
```json
{
  "boxes": [[x1, y1, x2, y2], ...],
  "classes": ["carpetweed", "morningglory", ...],
  "confidences": [0.95, 0.87, ...],
  "num_detections": 3
}
```

**Example using Python:**
```python
import requests

with open('field_image.jpg', 'rb') as f:
    response = requests.post(
        'http://localhost:8000/predict',
        files={'file': f}
    )
    predictions = response.json()
    print(f"Detected {predictions['num_detections']} weeds")
```

**Example using cURL:**
```bash
curl -X POST "http://localhost:8000/predict" \
     -H "accept: application/json" \
     -H "Content-Type: multipart/form-data" \
     -F "file=@field_image.jpg"
```

#### `GET /docs`
Interactive API documentation (Swagger UI).

#### `GET /`
Root endpoint with API information.

---

## 🤖 Model Information

### Architecture
- **Model**: YOLOv8n (nano variant)
- **Framework**: Ultralytics YOLOv8
- **Input Format**: RGB images (any size, auto-resized by model)
- **Output Format**: Bounding boxes, class labels, confidence scores

### Detected Classes

1. **Carpetweed** (`carpetweed`)
   - Color annotation: Green
   - Common in cotton fields

2. **Morning Glory** (`morningglory`)
   - Color annotation: Red
   - Invasive vine species

3. **Palmer Amaranth** (`palmer_amaranth`)
   - Color annotation: Blue
   - Highly competitive weed

### Model Performance
- Model trained on cotton field images
- Optimized for real-time inference
- Supports batch processing for multiple images

---

## 🐳 Docker Deployment

### Build and Run with Docker Compose

```bash
# Build and start all containers
docker-compose up --build

# Run in detached mode
docker-compose up -d

# View logs
docker-compose logs -f

# Stop containers
docker-compose down
```

### Individual Container Commands

```bash
# Build API container
docker build -f docker/Dockerfile.api -t cotton-weed-api .

# Build Streamlit container
docker build -f docker/Dockerfile.app -t cotton-weed-app .

# Run API container
docker run -p 8000:8000 -v $(pwd)/models:/app/models cotton-weed-api

# Run Streamlit container
docker run -p 8501:8501 -e API_URL=http://host.docker.internal:8000 cotton-weed-app
```

---

## ☁️ Cloud Deployment

### Frontend Deployment (Streamlit Cloud)

1. **Push code to GitHub**
   ```bash
   git add .
   git commit -m "Deploy to Streamlit Cloud"
   git push origin main
   ```

2. **Connect to Streamlit Cloud**
   - Go to [streamlit.io/cloud](https://streamlit.io/cloud)
   - Sign in with GitHub
   - Click "New app"
   - Select your repository
   - Set main file path: `app/main.py`

3. **Configure Environment Variables**
   - Add secret: `API_URL=http://your-vm-ip:8000`
   - Replace `your-vm-ip` with your backend VM's IP address

4. **Deploy**
   - Click "Deploy"
   - Wait for deployment (1-2 minutes)
   - Access your app at `https://your-app-name.streamlit.app`

### Backend Deployment (Google Cloud)

1. **Build Docker Image**
   ```bash
   docker build -f docker/Dockerfile.api -t gcr.io/PROJECT_ID/api:latest .
   ```

2. **Push to Google Container Registry**
   ```bash
   docker push gcr.io/PROJECT_ID/api:latest
   ```

3. **Deploy on Compute Engine**
   - Create VM instance
   - Install Docker
   - Pull and run container
   - Configure firewall rules for port 8000

4. **Get VM IP Address**
   ```bash
   gcloud compute instances describe INSTANCE_NAME \
       --zone=ZONE \
       --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
   ```

---

## ⚙️ Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `API_URL` | Backend API URL | `http://localhost:8000` |
| `PYTHONUNBUFFERED` | Python output buffering | `1` (for Docker) |

### Streamlit Configuration

Edit `.streamlit/config.toml` to customize:
- Theme colors
- Server settings
- UI preferences

### Model Configuration

Update `api/model_loader.py` to:
- Change model file path
- Adjust confidence thresholds
- Modify input image preprocessing

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow PEP 8 style guide
- Add docstrings to functions and classes
- Write tests for new features
- Update documentation as needed

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- [Ultralytics](https://ultralytics.com/) for YOLOv8
- [Streamlit](https://streamlit.io/) for the web framework
- [FastAPI](https://fastapi.tiangolo.com/) for the API framework

---

## 📧 Contact

For questions, issues, or contributions:
- Open an issue on [GitHub Issues](https://github.com/eljamani94/cotton-weed-detection/issues)
- Contact: [eljamani.aej@gmail.com]

---

<div align="center">

**Made with ❤️ for agricultural innovation**

⭐ Star this repo if you find it helpful!

</div>

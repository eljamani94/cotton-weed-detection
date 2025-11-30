# 🚀 Complete Setup Instructions

Follow these steps **in order** to set up your Cotton Weed Detection project.

## Step 1: Install Python

### Check if Python is installed:
```bash
python --version
```

### If not installed:
1. Go to https://www.python.org/downloads/
2. Download Python 3.8 or higher
3. **IMPORTANT**: During installation, check "Add Python to PATH"
4. Install

### Verify installation:
```bash
python --version
pip --version
```

## Step 2: Install Project Dependencies

### Windows:
1. Open PowerShell in the project folder
2. Run: `.\scripts\install_requirements.bat`

### Mac/Linux:
1. Open terminal in the project folder
2. Run: `chmod +x scripts/install_requirements.sh`
3. Run: `./scripts/install_requirements.sh`

### Manual installation (if scripts don't work):
```bash
# Create virtual environment
python -m venv cotton_weed

# Activate virtual environment
# Windows:
cotton_weed\Scripts\activate
# Mac/Linux:
source cotton_weed/bin/activate

# Install packages
pip install -r requirements.txt
```

## Step 3: Add Your Trained Model

1. **Find your trained model file** (the file you saved after training)
2. **Copy it** to the `models/` folder
3. **Common model file names:**
   - `model.pth` (PyTorch)
   - `model.pt` (PyTorch)
   - `best_model.pth`
   - `weights.pth`
   - `model.h5` (TensorFlow/Keras)
   - `model.onnx` (ONNX)

### If you don't know where your model is:
- Check your training script's output directory
- Look for files ending in `.pth`, `.pt`, `.h5`, `.onnx`, or `.pb`

## Step 4: Update Model Configuration

You need to tell the code about your model. Open `api/predictor.py` and update:

1. **Class names**: Replace `weed_class_0`, `weed_class_1` with your actual class names
2. **Model output format**: The code has examples for common formats, but you may need to adjust based on your model

### Example class names:
```python
class_names = ["cotton", "weed_type_1", "weed_type_2", "weed_type_3"]
```

## Step 5: Test Locally

### Terminal 1 - Start the API:
```bash
# Make sure virtual environment is activated
cd api
python main.py
```

You should see:
```
✅ Model loaded successfully
INFO:     Uvicorn running on http://0.0.0.0:8000
```

### Terminal 2 - Start the Streamlit App:
```bash
# Make sure virtual environment is activated
streamlit run app/main.py --server.port 8501
```

You should see:
```
You can now view your Streamlit app in your browser.
Local URL: http://localhost:8501
```

## Step 6: Test the Application

1. Open browser: http://localhost:8501
2. Try uploading an image or using camera (if on mobile)
3. Check if predictions appear

### If you see errors:

**Error: "Model file not found"**
- Make sure your model file is in the `models/` folder
- Check the file name matches what the code expects

**Error: "Model loading failed"**
- Check your model format matches what's in `api/model_loader.py`
- You may need to update the loading code for your specific model type

**Error: "Prediction failed"**
- Check `api/predictor.py` - you need to update the postprocessing function
- Make sure class names are correct

## Step 7: Install Docker (For Deployment)

### Windows:
1. Download Docker Desktop: https://www.docker.com/products/docker-desktop
2. Install and restart computer
3. Open Docker Desktop

### Verify:
```bash
docker --version
docker-compose --version
```

## Step 8: Test with Docker (Optional)

```bash
# Build and run
docker-compose up --build
```

Access at: http://localhost:8501

## Step 9: Deploy to Google Cloud

Follow the instructions in `scripts/deploy_gcp.md`

## 🆘 Need Help?

### Common Issues:

1. **"Module not found" error**
   - Make sure virtual environment is activated
   - Run: `pip install -r requirements.txt`

2. **"Port already in use"**
   - Change ports in `docker-compose.yml` or stop other services

3. **"Model predictions are wrong"**
   - Check `api/predictor.py` - update postprocessing logic
   - Verify class names match your training

4. **"Camera not working"**
   - Make sure you're accessing from HTTPS (required for camera)
   - Or use file upload instead

## 📝 Next Steps After Setup:

1. ✅ Test with sample images
2. ✅ Verify predictions are correct
3. ✅ Update class names in code
4. ✅ Deploy to Google Cloud
5. ✅ Test on mobile device
6. ✅ Set up real-time sync (if needed)

## 📞 What I Need From You:

1. **Your model file location** - Where is your trained model?
2. **Model format** - What file extension does it have?
3. **Class names** - What are the names of your weed classes?
4. **Model output format** - What does your model output? (This helps me update the code)

Let me know when you've completed these steps or if you encounter any issues!


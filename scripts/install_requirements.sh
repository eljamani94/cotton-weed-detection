#!/bin/bash
# Installation script for local development

echo "🚀 Installing Cotton Weed Detection Project Requirements"
echo "========================================================"

# Check Python version
python_version=$(python3 --version 2>&1 | awk '{print $2}')
echo "📦 Python version: $python_version"

# Create virtual environment
echo "📁 Creating virtual environment..."
python3 -m venv cotton_weed

# Activate virtual environment
echo "✅ Activating virtual environment..."
source cotton_weed/bin/activate

# Upgrade pip
echo "⬆️  Upgrading pip..."
pip install --upgrade pip

# Install requirements
echo "📥 Installing Python packages..."
pip install -r requirements.txt

echo ""
echo "✅ Installation complete!"
echo ""
echo "To activate the virtual environment, run:"
echo "  source cotton_weed/bin/activate"
echo ""
echo "To run the API:"
echo "  cd api && uvicorn main:app --reload --port 8000"
echo ""
echo "To run the Streamlit app:"
echo "  streamlit run app/main.py --server.port 8501"


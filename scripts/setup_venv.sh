#!/bin/bash
# Create and setup virtual environment for the project

echo "🚀 Setting up Virtual Environment for Cotton Weed Detection Project"
echo "===================================================================="

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed!"
    echo "Please install Python 3.8+ first."
    exit 1
fi

echo "✅ Python found:"
python3 --version

# Check if virtual environment already exists
if [ -d "cotton_weed" ]; then
    echo ""
    echo "⚠️  Virtual environment already exists!"
    echo ""
    read -p "Do you want to delete and recreate it? (y/n): " choice
    if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        echo ""
        echo "🗑️  Removing existing virtual environment..."
        rm -rf cotton_weed
        echo "✅ Old virtual environment removed."
    else
        echo ""
        echo "ℹ️  Keeping existing virtual environment."
        echo ""
        echo "To activate it, run:"
        echo "  source cotton_weed/bin/activate"
        exit 0
    fi
fi

echo ""
echo "📁 Creating new virtual environment..."
python3 -m venv cotton_weed

if [ $? -ne 0 ]; then
    echo "❌ Failed to create virtual environment!"
    exit 1
fi

echo "✅ Virtual environment created successfully!"
echo ""

# Activate virtual environment
echo "🔄 Activating virtual environment..."
source cotton_weed/bin/activate

# Upgrade pip
echo ""
echo "⬆️  Upgrading pip..."
pip install --upgrade pip

echo ""
echo "✅ Virtual environment setup complete!"
echo ""
echo "===================================================================="
echo "📝 Next Steps:"
echo "===================================================================="
echo ""
echo "1. The virtual environment is now ACTIVE (you'll see (cotton_weed) in your prompt)"
echo ""
echo "2. Install project dependencies:"
echo "   pip install -r requirements.txt"
echo ""
echo "3. To activate this environment in the future, run:"
echo "   source cotton_weed/bin/activate"
echo ""
echo "4. To deactivate, simply type:"
echo "   deactivate"
echo ""
echo "===================================================================="


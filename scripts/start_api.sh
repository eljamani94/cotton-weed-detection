#!/bin/bash
# Start the FastAPI backend

echo "🚀 Starting Cotton Weed Detection API..."
echo ""

# Activate virtual environment if it exists
if [ -d "cotton_weed" ]; then
    source cotton_weed/bin/activate
fi

# Start API
cd api
python main.py


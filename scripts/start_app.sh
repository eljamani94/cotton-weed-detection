#!/bin/bash
# Start the Streamlit frontend

echo "🚀 Starting Cotton Weed Detection App..."
echo ""

# Activate virtual environment if it exists
if [ -d "cotton_weed" ]; then
    source cotton_weed/bin/activate
fi

# Start Streamlit
streamlit run app/main.py --server.port 8501


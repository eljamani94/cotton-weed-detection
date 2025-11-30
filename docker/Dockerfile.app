# Streamlit Frontend Dockerfile
FROM python:3.9-slim

WORKDIR /app

# Install system dependencies (cache this layer)
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first (for better caching)
COPY requirements.txt .

# Install Python dependencies (cache this layer if requirements.txt unchanged)
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code LAST (this layer changes most often)
# Only this layer will rebuild when you edit files
COPY app/ ./app/

# Expose port
EXPOSE 8501

# Run Streamlit
CMD ["streamlit", "run", "app/main.py", "--server.port", "8501", "--server.address", "0.0.0.0"]


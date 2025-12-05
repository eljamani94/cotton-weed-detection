# Streamlit Frontend Dockerfile
FROM python:3.9-slim

WORKDIR /app

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    STREAMLIT_SERVER_MAX_UPLOAD_SIZE=2000 \
    STREAMLIT_SERVER_ENABLE_CORS=true \
    STREAMLIT_SERVER_FILE_WATCHER_TYPE=none

# Install system dependencies (cache this layer)
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first (for better caching)
COPY requirements.txt .
COPY requirements-streamlit.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt -r requirements-streamlit.txt && \
    pip install --no-cache-dir requests==2.31.0 urllib3==2.0.7

# Create a non-root user and switch to it
RUN adduser --disabled-password --gecos "" appuser && \
    chown -R appuser:appuser /app
USER appuser

# Copy app code (this layer changes most often)
COPY --chown=appuser:appuser app/ ./app/

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8501/_stcore/health || exit 1

# Expose port
EXPOSE 8501

# Run Streamlit with production settings
CMD ["streamlit", "run", "app/main.py", 
    "--server.port=8501", 
    "--server.address=0.0.0.0",
    "--server.maxUploadSize=2000",
    "--server.maxMessageSize=2000",
    "--browser.gatherUsageStats=false",
    "--logger.level=error"]


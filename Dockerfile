FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    HOME=/root

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        curl \
        gcc \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender-dev \
        libgl1-mesa-glx \
        libpoppler-cpp-dev \
        poppler-utils \
        tesseract-ocr \
        libspatialindex-dev && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python dependencies
RUN pip install --upgrade pip && \
    pip install \
        "kfp==2.0.1" \
        "huggingface_hub<1.0.0" \
        "sentence-transformers" \
        "transformers==4.28.1" \
        "tokenizers==0.13.2" \
        "docling>=1.3.0" \
        "pymilvus" \
        "boto3" \
        "marshmallow==3.19.0" \
        "environs==9.5.0" \
        "numpy<2.0.0"

# Ensure required folders exist and are writable
RUN mkdir -p /root/.cache /tmp/.EasyOCR /tmp/huggingface /tmp/torch && \
    chmod -R 777 /root /tmp

# Set working directory
WORKDIR /app

CMD ["python3"]

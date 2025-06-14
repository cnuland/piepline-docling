FROM python:3.11-slim

ENV GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"
ENV HF_HOME=/tmp/huggingface
ENV TORCH_HOME=/tmp/torch
ENV EASYOCR_CACHE_FOLDER=/tmp/.EasyOCR

# Set work directory
WORKDIR /root/

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    gcc \
    g++ \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
    libpoppler-cpp-dev \
    tesseract-ocr \
    tesseract-ocr-eng \
    ghostscript \
    wget \
    curl \
    unzip \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python packages
RUN pip install --upgrade pip && \
    pip install --no-cache-dir \
        --extra-index-url https://download.pytorch.org/whl/cpu \
        docling \
        pymilvus \
        sentence-transformers==2.2.2 \
        transformers==4.28.1 \
        tokenizers==0.13.2 \
        "numpy<2.0.0" \
        boto3 \
        marshmallow==3.19.0 \
        environs==9.5.0 \
    && rm -rf ~/.cache

# Create and set permissions for cache directories
RUN mkdir -p /tmp/huggingface /tmp/.EasyOCR /tmp/torch && \
    chmod -R 777 /tmp/huggingface /tmp/.EasyOCR /tmp/torch

# Optional: Copy a test script (minimal.py) if needed for standalone testing
# COPY docs/examples/minimal.py /root/minimal.py

# Final environment thread optimization
ENV OMP_NUM_THREADS=4

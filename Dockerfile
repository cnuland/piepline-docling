FROM python:3.11-slim

# Set environment vars
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libgl1 \
        libglib2.0-0 \
        libsm6 \
        libxrender1 \
        libxext6 \
        tesseract-ocr \
        poppler-utils \
        libpoppler-cpp-dev \
        git \
        curl \
        && rm -rf /var/lib/apt/lists/*

# Create runtime cache dirs with proper permissions
RUN mkdir -p /tmp/.EasyOCR /tmp/huggingface /tmp/torch && \
    chmod -R 777 /tmp/.EasyOCR /tmp/huggingface /tmp/torch

RUN pip install --upgrade pip && \
    pip install \
        kfp==2.0.1 \
        huggingface_hub==0.23.0 \
        sentence-transformers==2.5.1 \
        transformers==4.38.2 \
        tokenizers==0.13.2 \
        "docling>=2.0.0" \
        pymilvus \
        boto3 \
        marshmallow==3.19.0 \
        environs==9.5.0 \
        "numpy<2.0.0"

# Final permissions fix
RUN chmod -R a+rwx /root /tmp

# Entrypoint is handled by KFP, so we don't override CMD


FROM python:3.11-slim

# Set environment variables
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
        tesseract-ocr \
        libpq-dev \
        poppler-utils \
        libspatialindex-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Python libraries with pinned versions
RUN pip install --upgrade pip && \
    pip install \
        kfp==2.0.1 \
        huggingface_hub==0.19.4 \
        sentence-transformers==2.2.2 \
        transformers==4.28.1 \
        tokenizers==0.13.2 \
        docling \
        pymilvus \
        boto3 \
        marshmallow==3.19.0 \
        environs==9.5.0 \
        "numpy<2.0.0"

# Set up runtime directories with correct permissions
RUN mkdir -p /root/.cache /tmp/.EasyOCR /tmp/huggingface /tmp/torch && \
    chmod -R 777 /root /tmp

# Set workdir and entry
WORKDIR /app
CMD ["python3"]


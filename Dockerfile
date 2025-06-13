FROM python:3.11-slim-bookworm

ENV GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    libgl1 libglib2.0-0 curl wget git procps \
    && rm -rf /var/lib/apt/lists/*

# Set env vars for writable model/artifact caches
ENV EASYOCR_CACHE_FOLDER=/tmp/.EasyOCR \
    HF_HOME=/tmp/huggingface \
    HF_HUB_CACHE=/tmp/huggingface \
    TRANSFORMERS_CACHE=/tmp/huggingface \
    HF_DATASETS_CACHE=/tmp/huggingface \
    TORCH_HOME=/tmp/torch \
    PYTHONUNBUFFERED=1

# Create cache directories ahead of time to avoid permission errors
RUN mkdir -p $EASYOCR_CACHE_FOLDER \
    && mkdir -p $HF_HOME \
    && mkdir -p $HF_HUB_CACHE \
    && mkdir -p $TORCH_HOME \
    && chmod -R 777 /tmp

# Install docling and its dependencies (with CPU-only PyTorch)
RUN pip install --upgrade pip \
 && pip install --no-cache-dir \
    docling \
    boto3 \
    marshmallow==3.19.0 \
    environs==9.5.0 \
    sentence-transformers==2.2.2 \
    huggingface_hub==0.15.1 \
    transformers==4.30.2 \
    numpy<2.0.0 \
 --extra-index-url https://download.pytorch.org/whl/cpu \
 && rm -rf ~/.cache

# Optional: download Docling model artifacts at build time
RUN docling-tools models download || echo "Model prefetch failed — will download at runtime"

# On container environments, limit CPU thread usage
ENV OMP_NUM_THREADS=4

# Default working directory
WORKDIR /workspace


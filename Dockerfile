FROM python:3.11-slim-bookworm

ENV GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"

RUN apt-get update \
    && apt-get install -y libgl1 libglib2.0-0 curl wget git procps \
    && rm -rf /var/lib/apt/lists/*

# Set writable environment cache directories
ENV EASYOCR_CACHE_FOLDER=/tmp/.EasyOCR \
    HF_HOME=/tmp/huggingface \
    HF_HUB_CACHE=/tmp/huggingface \
    TRANSFORMERS_CACHE=/tmp/huggingface \
    HF_DATASETS_CACHE=/tmp/huggingface \
    TORCH_HOME=/tmp/torch \
    PYTHONUNBUFFERED=1

# Pre-create cache folders with permissions
RUN mkdir -p $EASYOCR_CACHE_FOLDER $HF_HOME $HF_HUB_CACHE $TORCH_HOME && chmod -R 777 /tmp

# Upgrade pip and install all dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir \
        docling \
        boto3 \
        marshmallow==3.19.0 \
        environs==9.5.0 \
        sentence-transformers==2.2.2 \
        transformers==4.30.2 \
        "numpy<2.0.0" \
        --extra-index-url https://download.pytorch.org/whl/cpu && \
    rm -rf ~/.cache

# Final thread settings
ENV OMP_NUM_THREADS=4

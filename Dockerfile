FROM python:3.11-slim-bookworm

ENV PYTHONUNBUFFERED=1 \
    EASYOCR_CACHE_FOLDER=/tmp/.EasyOCR \
    HF_HOME=/tmp/huggingface \
    HF_HUB_CACHE=/tmp/huggingface \
    TRANSFORMERS_CACHE=/tmp/huggingface \
    HF_DATASETS_CACHE=/tmp/huggingface \
    TORCH_HOME=/tmp/torch

# Install system dependencies
RUN apt-get update && \
    apt-get install -y libgl1 libglib2.0-0 curl wget git procps && \
    rm -rf /var/lib/apt/lists/*

# Create and set permissions on cache directories
RUN mkdir -p $EASYOCR_CACHE_FOLDER $HF_HOME $HF_HUB_CACHE $TRANSFORMERS_CACHE $HF_DATASETS_CACHE $TORCH_HOME && \
    chmod -R 777 /tmp

# Install Python packages (CPU-only PyTorch)
RUN pip install --upgrade pip && \
    pip install --no-cache-dir \
        docling \
        boto3 \
        marshmallow==3.19.0 \
        environs==9.5.0 \
        sentence-transformers==2.2.2 \
        huggingface_hub==0.15.1 \
        transformers==4.30.2 \
        numpy<2.0.0 \
        --extra-index-url https://download.pytorch.org/whl/cpu && \
    rm -rf ~/.cache

# Optional test script (you can remove or replace this)
COPY docs/examples/minimal.py /root/minimal.py

# Default thread limit
ENV OMP_NUM_THREADS=4

# Entry point (optional if using as a component image)
CMD ["python", "/root/minimal.py"]

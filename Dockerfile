FROM registry.fedoraproject.org/fedora:39

ENV GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"
ENV HF_HOME=/tmp/huggingface
ENV HF_HUB_CACHE=/tmp/huggingface
ENV TRANSFORMERS_CACHE=/tmp/huggingface
ENV HF_DATASETS_CACHE=/tmp/huggingface
ENV TORCH_HOME=/tmp/torch
ENV EASYOCR_CACHE_FOLDER=/tmp/.EasyOCR
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN dnf install -y \
        python3-pip \
        gcc \
        gcc-c++ \
        git \
        wget \
        unzip \
        poppler-utils \
        tesseract \
        tesseract-langpack-eng \
        cairo \
        cairo-devel \
        libjpeg-turbo-devel \
        zlib-devel \
        openblas-devel \
        freetype-devel \
        pkgconfig \
        make \
        ghostscript \
        which \
    && dnf clean all

# Install Python dependencies
RUN pip install --upgrade pip && pip install --no-cache-dir \
        docling \
        pymilvus \
        sentence-transformers \
        boto3 \
        marshmallow==3.19.0 \
        environs==9.5.0 \
        huggingface_hub==0.15.1 \
        transformers==4.30.2 \
        numpy<2.0.0 \
    --extra-index-url https://download.pytorch.org/whl/cpu \
    && rm -rf ~/.cache

# Ensure cache directories exist with proper permissions
RUN mkdir -p $EASYOCR_CACHE_FOLDER $HF_HOME $HF_HUB_CACHE $TORCH_HOME && \
    chmod -R 777 /tmp

# Pre-download Docling models to speed up runtime
RUN docling-tools models download

# On container environments, always set a thread budget
ENV OMP_NUM_THREADS=4

# Optional default workdir
WORKDIR /root

FROM registry.fedoraproject.org/fedora:39

ENV GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"
ENV HF_HOME=/tmp/huggingface
ENV TORCH_HOME=/tmp/torch
ENV EASYOCR_CACHE_FOLDER=/tmp/.EasyOCR
ENV PYTHONUNBUFFERED=1

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

# Create required cache folders with proper permissions
RUN mkdir -p /tmp/.EasyOCR /tmp/huggingface /tmp/torch && chmod -R 777 /tmp

# Install packages (leave huggingface_hub unpinned to allow docling to resolve it correctly)
RUN pip install --upgrade pip && \
    pip install --no-cache-dir \
        --extra-index-url https://download.pytorch.org/whl/cpu \
        docling \
        pymilvus \
        sentence-transformers \
        boto3 \
        marshmallow==3.19.0 \
        environs==9.5.0 \
        transformers==4.30.2 \
        "numpy<2.0.0" && \
    rm -rf ~/.cache



FROM registry.fedoraproject.org/fedora:39

ENV GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"
ENV HF_HOME=/tmp/huggingface
ENV TORCH_HOME=/tmp/torch
ENV EASYOCR_CACHE_FOLDER=/tmp/.EasyOCR

# Install system-level dependencies
RUN dnf install -y \
        python3-pip \
        gcc \
        gcc-c++ \
        git \
        wget \
        unzip \
        ffmpeg \
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

# Upgrade pip and install Python dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir \
        docling \
        boto3 \
        marshmallow==3.19.0 \
        environs==9.5.0 \
        "sentence-transformers==2.2.2" \
        "huggingface_hub==0.14.1" \
        "transformers==4.30.2" \
        "numpy<2.0.0" \
        "pymilvus==2.4.0" \
        --extra-index-url https://download.pytorch.org/whl/cpu && \
    rm -rf ~/.cache

# Create cache directories with safe permissions
RUN mkdir -p /tmp/huggingface /tmp/torch /tmp/.EasyOCR && \
    chmod -R 777 /tmp/huggingface /tmp/torch /tmp/.EasyOCR

# Pre-download docling models and set permissions
RUN mkdir -p /root/.cache/docling && \
    docling-tools models download && \
    chmod -R 755 /root/.cache/docling

# Set working directory
WORKDIR /app

# Entrypoint placeholder
CMD ["/bin/bash"]


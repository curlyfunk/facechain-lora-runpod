FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=on \
    SHELL=/bin/bash

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Системни зависимости
RUN apt update && \
    apt upgrade -y && \
    apt install -y \
      python3-pip \
      git \
      wget \
      curl \
      ffmpeg \
      libgl1-mesa-glx \
      libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Python зависимости – добавяме само базови, ще надграждаме при нужда
RUN pip install --upgrade pip && \
    pip install runpod

# Копиране на скриптове
COPY --chmod=755 handler.py /workspace/handler.py
COPY --chmod=755 start.sh /start.sh

ENTRYPOINT ["/start.sh"]

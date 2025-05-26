FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace

# Основни пакети
RUN apt update && apt install -y git python3-pip ffmpeg libgl1 unzip

# Python зависимости
RUN pip install --upgrade pip && \
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 && \
    pip install transformers datasets accelerate peft bitsandbytes safetensors runpod diffusers xformers scipy tqdm

# Clone FaceChain (LoRA training)
RUN git clone https://github.com/modelscope/facechain.git
WORKDIR /workspace/facechain

# Копира handler + старт скрипт
COPY --chmod=755 handler.py /workspace/facechain/handler.py
COPY --chmod=755 start.sh /start.sh

ENTRYPOINT ["/start.sh"]

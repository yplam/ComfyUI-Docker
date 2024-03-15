FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-runtime as base

ARG APT_MIRROR=mirrors.aliyun.com
ARG PIP_INDEX=https://pypi.org/simple
ARG TIMEZONE=Asia/Shanghai
ARG UID=1000
ARG GID=1000
ARG UNAME=ComfyUI

ENV DEBIAN_FRONTEND=noninteractive

RUN \
    export LD_LIBRARY_PATH=/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH \
    && sed -e "s/archive.ubuntu.com/${APT_MIRROR}/g" \
        -e "s/security.ubuntu.com/${APT_MIRROR}/g" -i /etc/apt/sources.list \
    && ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone \
    && apt-get -o Acquire::ForceIPv4=true update && apt-get -o Acquire::ForceIPv4=true install -y \
    curl \
    wget \
    build-essential \
    python3-dev \
    python3-pip \
    git \
    ffmpeg \
    libgl1-mesa-glx \
    vim \
    && rm -rf /var/lib/apt/lists/* \
    && date

RUN \
    pip install --no-cache-dir --upgrade -i $PIP_INDEX pip \
    && pip config set global.index-url $PIP_INDEX 

COPY ./requirements_base /tmp/requirements_base
RUN find /tmp/requirements_base -name requirements.txt \
    && find /tmp/requirements_base -name requirements.txt -exec pip install --no-cache-dir -r {} \; \
    && rm -rf /tmp/requirements_base

RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME
WORKDIR /home/ComfyUI


From base as comfyui-comfyui

ARG UNAME=ComfyUI

COPY ./requirements_comfyui /tmp/requirements_comfyui
RUN find /tmp/requirements_comfyui -name requirements.txt \
    && find /tmp/requirements_comfyui -name requirements.txt -exec pip install --no-cache-dir -r {} \; \
    && rm -rf /tmp/requirements_comfyui

USER $UNAME
EXPOSE 8188
CMD ["python3", "/home/ComfyUI/main.py", "--listen", "--port", "8188"]

# ENTRYPOINT ["tail", "-f", "/dev/null"]


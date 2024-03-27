FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04 as base

ARG APT_MIRROR=mirrors.aliyun.com
ARG PIP_INDEX=https://mirrors.aliyun.com/pypi/simple
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
    libjpeg-dev \
    libpng-dev \
    git \
    ffmpeg \
    vim \
    && rm -rf /var/lib/apt/lists/* \
    && date

RUN \
    pip install --no-cache-dir --upgrade -i $PIP_INDEX pip \
    && pip config set global.index-url $PIP_INDEX \
    && pip install --no-cache-dir torch xformers --index-url https://download.pytorch.org/whl/cu121 


COPY ./requirements_base /tmp/requirements_base
RUN find /tmp/requirements_base -name requirements.txt \
    && find /tmp/requirements_base -name requirements.txt -exec pip install --no-cache-dir -r {} \; \
    && rm -rf /tmp/requirements_base

RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME
WORKDIR /home/ComfyUI

############################################################################################

From base as comfyui-comfyui

ARG UNAME=ComfyUI

COPY ./requirements_comfyui /tmp/requirements
RUN set -e; \
    for file in $(find /tmp/requirements -type f -name 'requirements*.txt'); do \
        pip install --extra-index-url https://download.pytorch.org/whl/cu121 --no-cache-dir -r "$file" || { echo "Failed to install dependencies from $file"; exit 1; }; \
    done \
    && rm -rf /tmp/requirements

USER $UNAME
EXPOSE 8188
CMD ["python3", "/home/ComfyUI/app/main.py", "--listen", "--port", "8188"]

############################################################################################

From base as comfyui-ootd

ARG UNAME=ComfyUI

COPY ./requirements_ootd /tmp/requirements
RUN set -e; \
    for file in $(find /tmp/requirements -type f -name 'requirements*.txt'); do \
        pip install --extra-index-url https://download.pytorch.org/whl/cu121 --no-cache-dir -r "$file" || { echo "Failed to install dependencies from $file"; exit 1; }; \
    done \
    && rm -rf /tmp/requirements

USER $UNAME
EXPOSE 8188
CMD ["python3", "/home/ComfyUI/app/main.py", "--listen", "--port", "8188"]

###########################################################################################

From base as comfyui-3dpack

ARG UNAME=ComfyUI
ARG TORCH_CUDA_ARCH_LIST='7.5;8.0;8.6;8.9;9.0+PTX'
RUN pip install --no-cache-dir kiui

COPY ./requirements_3dpack /tmp/requirements
RUN set -e; \
    for file in $(find /tmp/requirements -type f -name 'requirements*.txt'); do \
        pip install --extra-index-url https://download.pytorch.org/whl/cu121 --no-cache-dir -r "$file" || { echo "Failed to install dependencies from $file"; exit 1; }; \
    done \
    && rm -rf /tmp/requirements

COPY ./requirements_3dpack.txt /tmp
RUN set -e; \
    pip install --extra-index-url https://download.pytorch.org/whl/cu121 --no-cache-dir -r /tmp/requirements_3dpack.txt || exit 1 \
    && rm -rf /tmp/requirements_3dpack.txt


USER $UNAME
EXPOSE 8188
CMD ["python3", "/home/ComfyUI/app/main.py", "--listen", "--port", "8188"]


############################################################################################

From base as comfyui-flowty

ARG UNAME=ComfyUI

COPY ./requirements_flowty /tmp/requirements
RUN set -e; \
    for file in $(find /tmp/requirements -type f -name 'requirements*.txt'); do \
        pip install --extra-index-url https://download.pytorch.org/whl/cu121 --no-cache-dir -r "$file" || { echo "Failed to install dependencies from $file"; exit 1; }; \
    done \
    && rm -rf /tmp/requirements

USER $UNAME
EXPOSE 8188
CMD ["python3", "/home/ComfyUI/app/main.py", "--listen", "--port", "8188"]

############################################################################################

From base as comfyui-video

ARG UNAME=ComfyUI

COPY ./requirements_video /tmp/requirements
RUN set -e; \
    for file in $(find /tmp/requirements -type f -name 'requirements*.txt'); do \
        pip install --extra-index-url https://download.pytorch.org/whl/cu121 --no-cache-dir -r "$file" || { echo "Failed to install dependencies from $file"; exit 1; }; \
    done \
    && rm -rf /tmp/requirements

USER $UNAME
EXPOSE 8188
CMD ["python3", "/home/ComfyUI/app/main.py", "--listen", "--port", "8188"]

############################################################################################

From comfyui-video as comfyui-controlnet-video

ARG UNAME=ComfyUI

COPY ./requirements_controlnet_video /tmp/requirements
RUN set -e; \
    for file in $(find /tmp/requirements -type f -name 'requirements*.txt'); do \
        pip install --extra-index-url https://download.pytorch.org/whl/cu121 --no-cache-dir -r "$file" || { echo "Failed to install dependencies from $file"; exit 1; }; \
    done

RUN pip install --no-cache-dir fvcore omegaconf

USER $UNAME
EXPOSE 8188
CMD ["python3", "/home/ComfyUI/app/main.py", "--listen", "--port", "8188"]
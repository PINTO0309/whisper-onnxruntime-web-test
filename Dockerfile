FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USERNAME=user
ARG WKDIR=/onnxruntime-inference-examples

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get install -y \
        nano python3-pip python3-mock libpython3-dev \
        libpython3-all-dev python-is-python3 wget curl cmake \
        software-properties-common sudo pkg-config libhdf5-dev git \
        nodejs npm \
    && sed -i 's/# set linenumbers/set linenumbers/g' /etc/nanorc \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install pip -U \
    onnxruntime==1.18.1 \
    librosa==0.10.2.post1

RUN \
    # Install ort-whisper, Olive
    # Fix: js/ort-whisper doesn't work with latest onnxruntime(> 1.16) #374
    # https://github.com/microsoft/onnxruntime-inference-examples/issues/374
    git clone https://github.com/PINTO0309/onnxruntime-inference-examples.git \
    && cd onnxruntime-inference-examples \
    && pushd js/ort-whisper \
    && npm install \
    && npm run build \
    && git clone https://github.com/microsoft/Olive.git \
    && pushd Olive \
    && git checkout e64ba0a27feb019323060ba10bd8fd15b95f1aef \
    && python -m pip install . \
    && pushd examples/whisper \
    && python -m pip install -r requirements.txt \
    && npm install light-server

RUN echo "root:root" | chpasswd \
    && adduser --disabled-password --gecos "" "${USERNAME}" \
    && echo "${USERNAME}:${USERNAME}" | chpasswd \
    && echo "%${USERNAME}    ALL=(ALL)   NOPASSWD:    ALL" >> /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && mkdir -p ${WKDIR} \
    && chown -R ${USERNAME}:${USERNAME} ${WKDIR}

USER ${USERNAME}
WORKDIR ${WKDIR}
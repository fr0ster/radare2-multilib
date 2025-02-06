# Using debian latest as base image.
FROM debian:latest

# Label base
LABEL maintainer="Alex Kislitsa"

# Radare version
ARG R2_VERSION=master
ARG R2_TAG=5.9.8

ENV R2_VERSION=${R2_VERSION}
ENV R2_TAG=${R2_TAG}

RUN echo -e "Building versions:\n\
  R2_VERSION=${R2_VERSION}\n\
  R2_TAG=${R2_TAG}"

# Build radare2 in a volume to minimize space used by build
VOLUME ["/mnt"]

# Install all build dependencies
# Install bindings
# Build and install radare2 on master branch
# Remove all build dependencies
# Cleanup
RUN DEBIAN_FRONTEND=noninteractive dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  curl vim \
  gcc-multilib g++-multilib gdb tmux cmake \
  git bison flex xz-utils pkg-config \
  make socat netcat-traditional pkg-config \
  gnupg2 wget \
  python3-pip pipx python3-capstone pkg-config patch \
  less grep unzip

# Create non-root user
RUN useradd -m r2 && \
  echo "r2:r2" | chpasswd

# Initilise base user
USER r2
WORKDIR /home/r2
ENV HOME=/home/r2

# Setup r2env, r2pm and pwn tools
RUN \
  echo "export GIT_PYTHON_REFRESH=quiet" >> ${HOME}/.bashrc && \
  echo "export PATH=~/.local/bini:~/.r2env/bin:$PATH" >> ${HOME}/.bashrc && \
  export PATH=~/.local/bin/:~/.r2env/versions/radare2@${R2_TAG}/bin:$PATH && \
  git config --global pull.rebase false && \
  pip install --no-cache-dir --break-system-packages r2pipe && \
  pipx install pwntools && \
  pipx install ropper && \
  pipx install ropgadget && \
  pipx install r2env && \
  r2env init && r2env add radare2@${R2_TAG} && r2env use radare2@${R2_TAG} && \
  export PATH=~/.local/bin:~/.r2env/bin:$PATH && r2pm -U && r2pm -i r2ghidra r2ghidra-sleigh

# Base command for container
CMD ["/bin/bash"]

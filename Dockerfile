# r2docker
# ========
#
# Requires 1GB of free disk space
#
# Build docker image with:
# $ docker build -t r2docker:latest .
#
# Run the docker image:
# $ docker images
# $ export DOCKER_IMAGE_ID=$(docker images --format '{{.ID}}' -f 'label=r2docker')
# $ docker run -ti --cap-drop=ALL r2docker:latest
#
# Once you quit the bash session get the container id with:
# $ docker ps -a | grep bash
#
# To get into that shell again just type:
# $ docker start -ai <containedid>
#
# To share those images:
# $ docker export <containerid> | xz > container.xz
# $ xz -d < container.xz | docker import -
#
#
# If you willing to debug a program within Docker, you should run it with CAP_SYS_PTRACE:
#
# $ docker run -it --cap-drop=ALL --cap-add=SYS_PTRACE r2docker:latest
# $ r2 -d /bin/true
#

# Using debian 9 as base image.
FROM debian:11

# Label base
# luckycatalex/radare2-multilib 5.6.8
LABEL maintainer="Alex Kislitsa"
LABEL image="luckycatalex/radare2-multilib"
LABEL version="5.6.8"

# Radare version
ARG R2_VERSION=master
ARG R2_TAG=5.6.8
# R2pipe python version
ARG R2_PIPE_PY_VERSION=1.6.5

ENV R2_VERSION ${R2_VERSION}
ENV R2_TAG ${R2_TAG}
ENV R2_PIPE_PY_VERSION ${R2_PIPE_PY_VERSION}

RUN echo -e "Building versions:\n\
  R2_VERSION=${R2_VERSION}\n\
  R2_TAG=${R2_TAG}\n\
  R2_PIPE_PY_VERSION=${R2_PIPE_PY_VERSION}"

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
  curl \
  gcc-multilib g++-multilib gdb tmux cmake \
  git \
  bison flex xz-utils \
  pkg-config \
  make socat netcat pkg-config \
  gnupg2 \
  wget \
  python3-pip python3-capstone pkg-config patch \
  less grep unzip

WORKDIR /mnt

RUN git clone -q --depth 1 https://github.com/radareorg/radare2.git -b ${R2_TAG} && cd radare2 && \
  git switch -c ${R2_TAG} && \
  ./sys/install.sh --install && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create non-root user
RUN useradd -m r2 && \
  echo "r2:r2" | chpasswd

# Initilise base user
USER r2
WORKDIR /home/r2
ENV HOME /home/r2

# Setup r2pm
RUN git config --global pull.rebase false && \
  r2pm init && \
  r2pm update && r2pm -i r2ghidra  && \
  chown -R r2:r2 /home/r2/.config && \
  pip install --upgrade pip==22.0.4 --no-warn-script-location && \
  pip install r2pipe=="$R2_PIPE_PY_VERSION" && \
  pip install --upgrade pwntools==4.8.0 ropper==1.13.6 ropgadget==6.7 --no-warn-script-location && \
  echo "export PATH=~/.local/bin:$PATH" >> ${HOME}/.bashrc

# Base command for container
CMD ["/bin/bash"]

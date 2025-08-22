# slim container image for ansible/python development
FROM python:3.11-slim

# Set environment variables for non-interactive apt-get operations
ENV DEBIAN_FRONTEND=noninteractive

# Don't autocompile python
ENV PYTHONDONTWRITEBYTECODE=1

# set UV_LINK_MODE to copy as the venv will be a bind mount
ENV UV_LINK_MODE=copy

# update repos and packages
RUN apt-get update && apt-get upgrade -y

# install curl to fetch tailscale repos
RUN apt-get install -y curl

# install packages
RUN apt-get install -y --no-install-recommends \
    bash-completion \
    dnsutils \
    iputils-ping \
    iproute2 \
    jq \
    git \
    less \
    openssh-client \
    procps \
    sshpass \
    vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# install packages
ARG UV_VERSION=0.8.4
ARG YQ_VERSION=4.47.1

RUN curl -sLS https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-x86_64-unknown-linux-gnu.tar.gz \
    | tar xz -C /opt \
  && ln -s /opt/uv-x86_64-unknown-linux-gnu/* /usr/local/bin

RUN curl https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 -Lo /usr/bin/yq \
  && chmod +x /usr/bin/yq

CMD ["/bin/bash"]

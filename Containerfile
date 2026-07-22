FROM registry.access.redhat.com/ubi9/ubi:9.8-1784625744

ARG REPO_OWNER

LABEL org.opencontainers.image.title="ubi9-dev"
LABEL org.opencontainers.image.description="Personal UBI 9 development base image for DevPod/devcontainer-style development"
LABEL org.opencontainers.image.source="https://github.com/${REPO_OWNER}/base-devcontainer-image"
LABEL org.opencontainers.image.licenses="MIT"

# Install all needed packages at build time as root.
RUN dnf install -y \
  git \
  zsh \
  wget \
  unzip \
  openssh-clients \
  procps-ng \
  hostname \
  && dnf clean all \
  && rm -rf /var/cache/dnf

# Install mise globally so every project/user can use it.
RUN curl https://mise.run | sh

RUN mkdir -p /workspaces \
  && chmod 0777 /workspaces

WORKDIR /workspaces

CMD ["/usr/bin/zsh"]

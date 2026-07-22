FROM registry.access.redhat.com/ubi9/ubi:9.8-1784625744

ARG REPO_OWNER
ARG USERNAME=dev

LABEL org.opencontainers.image.title="ubi9-dev"
LABEL org.opencontainers.image.description="Personal UBI 9 development base image for DevPod/devcontainer-style development"
LABEL org.opencontainers.image.source="https://github.com/${REPO_OWNER}/base-devcontainer-image"
LABEL org.opencontainers.image.licenses="MIT"

# Install all needed packages at build time as root.
RUN dnf install -y \
  git \
  gcc-c++ \
  make \
  cmake \
  gcc \
  zsh \
  wget \
  unzip \
  openssh-clients \
  procps-ng \
  hostname \
  && dnf clean all \
  && rm -rf /var/cache/dnf

RUN dnf install -y \
  python3 \
  python3-pip \
  && curl -fsSL \
  "https://github.com/neovim/neovim/releases/download/v0.11.7/nvim-linux-x86_64.tar.gz" \
  -o /tmp/nvim.tar.gz \
  && tar -C /opt -xzf /tmp/nvim.tar.gz \
  && ln -snf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim \
  && rm -f /tmp/nvim.tar.gz \
  && dnf clean all \
  && rm -rf /var/cache/dnf# Generic user required for Podman keep-id and DevPod setup.

RUN groupadd --gid 1000 "${USERNAME}" \
  && useradd \
  --uid 1000 \
  --gid 1000 \
  --create-home \
  --shell /usr/bin/zsh \
  "${USERNAME}"

# Install mise globally so every project/user can use it.

# COPY --from=jdxcode/mise /usr/local/bin/mise /usr/local/bin/
RUN curl -fsSL https://mise.run \
  | MISE_INSTALL_PATH=/usr/local/bin/mise sh

RUN mkdir -p /workspaces \
  && chown "${USERNAME}":"${USERNAME}" /workspaces \
  && chmod 0755 /workspaces

WORKDIR /workspaces

CMD ["/usr/bin/zsh"]

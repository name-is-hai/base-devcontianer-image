FROM registry.access.redhat.com/ubi9/ubi:9.8-1784625744

ARG REPO_OWNER

LABEL org.opencontainers.image.title="ubi9-dev"
LABEL org.opencontainers.image.description="Personal UBI 9 development base image for DevPod/devcontainer-style development"
LABEL org.opencontainers.image.source="https://github.com/${REPO_OWNER}/base-devcontainer-image"
LABEL org.opencontainers.image.licenses="MIT"

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=1000

# Install all needed packages at build time as root.
RUN dnf install -y \
  git \
  zsh \
  curl \
  neovim \
  mise \
  wget \
  unzip \
  openssh-clients \
  procps-ng \
  hostname \
  util-linux \
  && dnf clean all \
  && rm -rf /var/cache/dnf

RUN if ! getent group "${USER_GID}" >/dev/null; then \
  groupadd --gid "${USER_GID}" "${USERNAME}"; \
  fi \
  && if ! id -u "${USERNAME}" >/dev/null 2>&1; then \
  useradd \
  --uid "${USER_UID}" \
  --gid "${USER_GID}" \
  --create-home \
  --shell /usr/bin/zsh \
  "${USERNAME}"; \
  fi

RUN mkdir -p /workspaces \
  && chown -R "${USERNAME}:${USERNAME}" /workspaces

USER ${USERNAME}

RUN mkdir -p "$HOME/.local/bin" \
  && curl -fsSL https://mise.run | MISE_INSTALL_PATH="$HOME/.local/bin/mise" sh

ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

WORKDIR /workspaces

CMD ["/usr/bin/zsh"]

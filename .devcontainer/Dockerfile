# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/base:jammy

ARG LOCAL_USER=vscode
ENV LOCAL_USER=${LOCAL_USER}

###############################################################################
# 1. System packages (root)                                                   #
###############################################################################
USER root
RUN apt-get update && \
    apt-get install -y \
        python3 \
        git \
        curl \
        build-essential \
        ca-certificates \
        zip \
    && rm -rf /var/lib/apt/lists/*

###############################################################################
# 2. Add the uv binary (distroless copy, pinned)                              #
###############################################################################
# Copies 2 tiny statically linked binaries: /uv and /uvx                     #
COPY --from=ghcr.io/astral-sh/uv:0.7.6 /uv /uvx /usr/local/bin/

###############################################################################
# 3. Regular user setup                                                       #
###############################################################################
USER vscode
WORKDIR /app
ENV PATH="/home/vscode/.local/bin:${PATH}"
ENV UV_SYSTEM_PYTHON=1

###############################################################################
# 4. Dependency layer (best-cache-practice)                                   #
###############################################################################
COPY --chown=vscode:vscode pyproject.toml uv.lock ./
RUN --mount=type=cache,target=/home/vscode/.cache/uv \
    uv sync --system --frozen

###############################################################################
# 5. Application code                                                         #
###############################################################################

COPY --chown=vscode:vscode . /app

################################################################################
# Git + pre‑commit                                                              #
################################################################################
RUN git config --global credential.useHttpPath true \
 && git config --global user.email "${LOCAL_USER}@gmail.com" \
 && git config --global user.name  "${LOCAL_USER}"

################################################################################
# Databricks CLI                                                                #
################################################################################
ENV DATABRICKS_CONFIG_FILE="/app/.databrickscfg"
RUN curl -fsSL https://raw.githubusercontent.com/databricks/setup-cli/main/install.sh | sudo sh

################################################################################
# Convenience alias                                                             #
################################################################################
RUN echo "alias dab='databricks bundle'" >> ~/.bashrc \
 && echo '#!/bin/bash\ndatabricks bundle "$@"' | sudo tee /usr/local/bin/dab >/dev/null \
 && sudo chmod +x /usr/local/bin/dab

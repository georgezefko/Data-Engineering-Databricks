# # syntax=docker/dockerfile:1
# FROM mcr.microsoft.com/devcontainers/base:jammy

# ARG LOCAL_USER=vscode
# ENV LOCAL_USER=${LOCAL_USER}

# ###############################################################################
# # 1. System packages (root)                                                   #
# ###############################################################################
# USER root
# RUN apt-get update && \
#     apt-get install -y \
#         python3 \
#         git \
#         curl \
#         build-essential \
#         ca-certificates \
#         zip \
#     && rm -rf /var/lib/apt/lists/*

# ###############################################################################
# # 2. Add the uv binary (distroless copy, pinned)                              #
# ###############################################################################
# # Copies 2 tiny statically linked binaries: /uv and /uvx                     #
# COPY --from=ghcr.io/astral-sh/uv:0.7.6 /uv /uvx /usr/local/bin/

# ###############################################################################
# # 3. Regular user setup                                                       #
# ###############################################################################
# USER vscode
# WORKDIR /app
# ENV PATH="/home/vscode/.local/bin:${PATH}"
# ENV UV_SYSTEM_PYTHON=1

# ###############################################################################
# # 4. Dependency layer (best-cache-practice)                                   #
# ###############################################################################
# COPY --chown=vscode:vscode pyproject.toml uv.lock ./
# RUN --mount=type=cache,target=/home/vscode/.cache/uv \
#     uv sync --system --frozen

# ###############################################################################
# # 5. Application code                                                         #
# ###############################################################################

# COPY --chown=vscode:vscode . /app

# ################################################################################
# # Git + pre‑commit                                                              #
# ################################################################################
# RUN git config --global credential.useHttpPath true \
#  && git config --global user.email "${LOCAL_USER}@gmail.com" \
#  && git config --global user.name  "${LOCAL_USER}"

# ################################################################################
# # Databricks CLI                                                                #
# ################################################################################
# ENV DATABRICKS_CONFIG_FILE="/app/.databrickscfg"
# RUN curl -fsSL https://raw.githubusercontent.com/databricks/setup-cli/main/install.sh | sudo sh

# ################################################################################
# # Convenience alias                                                             #
# ################################################################################
# RUN echo "alias dab='databricks bundle'" >> ~/.bashrc \
#  && echo '#!/bin/bash\ndatabricks bundle "$@"' | sudo tee /usr/local/bin/dab >/dev/null \
#  && sudo chmod +x /usr/local/bin/dab


FROM mcr.microsoft.com/devcontainers/base:jammy

# Use to set the git config
ARG LOCAL_USER

# Update and install packages
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    python3-setuptools \
    curl \
    pipx \
    build-essential \
    zip \
    && rm -rf /var/lib/apt/lists/*

    # Create working directory
WORKDIR /app

# Install UV
COPY --from=ghcr.io/astral-sh/uv:0.7.6 /uv /uvx /bin/
ENV UV_NATIVE_TLS=1
ENV UV_COMPILE_BYTE=1
ENV UV_LINK_MODE=copy

# Create and activate virtual environment
ENV VIRTUAL_ENV=/app/.venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Copy dependency files first for better caching
COPY pyproject.toml uv.lock ./

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-install-project

# Copy the rest of the project
COPY . .

# Install dependencies with UV
RUN uv pip install -e ".[dev]"


RUN git config --system credential.useHttpPath true \
 && git config --system user.email "${LOCAL_USER}@gmail.com" \
 && git config --system user.name  "${LOCAL_USER}"

# Setup Databricks config file path
ENV DATABRICKS_CONFIG_FILE="/app/.databrickscfg"
# Download Databricks CLI
RUN curl -fsSL https://raw.githubusercontent.com/databricks/setup-cli/main/install.sh | sh

# Create alias for Databricks Asset Bundle
RUN echo "alias dab='databricks bundle'" >> ~/.bashrc && \
    echo "alias dab='databricks bundle'" >> ~/.profile && \
    echo "alias dab='databricks bundle'" >> /etc/bash.bashrc && \
    echo '#!/bin/bash\ndatabricks bundle "$@"' > /usr/local/bin/dab && \
    chmod +x /usr/local/bin/dab

CMD ["bash"]

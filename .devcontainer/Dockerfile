# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/base:jammy

################################################################################
# Build‑time args                                                               #
################################################################################
ARG LOCAL_USER=vscode
ENV LOCAL_USER=${LOCAL_USER}

################################################################################
# System packages (as root)                                                     #
################################################################################
USER root
RUN apt-get update && apt-get install -y \
    git python3 python3-pip python3-setuptools \
    curl pipx build-essential zip \
 && rm -rf /var/lib/apt/lists/*

################################################################################
# Switch back to the unprivileged vscode user                                   #
################################################################################
USER vscode
ENV PATH="/home/vscode/.local/bin:${PATH}" 
WORKDIR /app

################################################################################
# Copy only what each step needs (better cache)                                 #
################################################################################
COPY --chown=vscode:vscode requirements.txt /tmp/requirements.txt
RUN pip install --user -r /tmp/requirements.txt

COPY --chown=vscode:vscode . /app

################################################################################
# Git + pre‑commit                                                              #
################################################################################
RUN git config --global credential.useHttpPath true \
 && git config --global user.email "${LOCAL_USER}@gmail.com" \
 && git config --global user.name  "${LOCAL_USER}" \
 && git init \
 && pre-commit install

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

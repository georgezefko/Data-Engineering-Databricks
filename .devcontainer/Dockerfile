FROM mcr.microsoft.com/devcontainers/base:jammy

ARG LOCAL_USER

RUN apt-get update \
    && apt-get install -y \
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
COPY . /app

# Fix for pusing to the repo

RUN git config --global crednetial.useHttpPath true
RUN git config --global user.email "${LOCAL_USER}}@gmail.com"

# Setup Datbricks config file path
ENV DATABRICKS_CONFIG_FILE="app/.databrickscfg"

# create alias for databricks asset bundle

RUN echo "alias dab = 'databricks bundle'" >>  ~/.bashrc && \
    echo "alias dab = 'databricks bundle'" >>  ~/.profile && \
    echo "alias dab = 'databricks bundle'" >> /etc/bash.bashcr && \
    echo '#!/bin/bash\ndatabricks bundle "$@"' > /usr/local/bin/dab && \
    chmod +x /usr/local/bin/dab

# Download databricks CLI
RUN curl -fsSL https://raw.githubusercontent.com/databricks/setup-cli/main/install.sh | sh

# Install python dependencies
RUN pip install -r requirements.txt
RUN git init && pre-commit install
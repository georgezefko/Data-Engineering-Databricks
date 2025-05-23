
FROM mcr.microsoft.com/devcontainers/base:jammy


ARG LOCAL_USER=vscode



RUN apt-get update && apt-get install -y \
    git python3 python3-pip python3-setuptools \
    curl pipx build-essential zip \
 && rm -rf /var/lib/apt/lists/*


WORKDIR /app


COPY . /app
RUN pip install -r requirements.txt

RUN git config --system credential.useHttpPath true \
 && git config --system user.email "${LOCAL_USER}@gmail.com" \
 && git config --system user.name  "${LOCAL_USER}"

RUN pre-commit install --allow-missing-config


ENV DATABRICKS_CONFIG_FILE="/app/.databrickscfg"
RUN curl -fsSL https://raw.githubusercontent.com/databricks/setup-cli/main/install.sh | sudo sh


RUN echo "alias dab='databricks bundle'" >> ~/.bashrc \
 && echo '#!/bin/bash\ndatabricks bundle "$@"' | sudo tee /usr/local/bin/dab >/dev/null \
 && sudo chmod +x /usr/local/bin/dab

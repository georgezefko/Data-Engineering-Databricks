#!/usr/bin/env bash
set -euo pipefail

echo "→ Wiring pre-commit hook"
pre-commit install --install-hooks


echo "→ Interactive Databricks login"
databricks auth login --profile data-engineering-databricks


echo "✔ Post-create steps complete"

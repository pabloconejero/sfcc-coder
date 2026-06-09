#!/usr/bin/env bash
# Arranca el MCP server sfcc-dev-mcp.
# - Si existe ./dw.json -> modo completo (docs + sandbox).
# - Si no existe        -> modo docs-only (sin credenciales). Útil en el portátil del trabajo.
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ -f "dw.json" ]]; then
  echo "[sfcc-coder] dw.json encontrado -> modo completo (sandbox)"
  exec npx -y sfcc-dev-mcp --dw-json ./dw.json
else
  echo "[sfcc-coder] sin dw.json -> modo docs-only"
  echo "[sfcc-coder] (copia dw.json.example a dw.json y rellena credenciales para modo completo)"
  exec npx -y sfcc-dev-mcp
fi

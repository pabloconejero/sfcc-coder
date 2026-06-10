#!/usr/bin/env bash
# Verifica el stack: Ollama + modelo + MCP.
set -uo pipefail
OLLAMA_URL="${OLLAMA_URL:-http://localhost:11434}"

echo "== 1/3 Ollama =="
if curl -sf "$OLLAMA_URL/v1/models" > /tmp/ollama_models.json; then
  echo "OK - respondiendo en $OLLAMA_URL"
  grep -o '"id":"[^"]*"' /tmp/ollama_models.json | sed 's/"id":/  - /; s/"//g'
else
  echo "FALLO - Ollama no responde (¿servicio arrancado?)"
fi

echo "== 2/3 Generacion =="
RESP=$(curl -sf "$OLLAMA_URL/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d '{"model":"sfcc-coder","messages":[{"role":"user","content":"di OK"}],"max_tokens":5}' || true)
if [[ -n "$RESP" ]]; then echo "OK - sfcc-coder genera"; else echo "FALLO - revisa 'ollama list' y el nombre del modelo"; fi

echo "== 3/3 MCP (sfcc-dev) =="
if pgrep -f "sfcc-dev-mcp" > /dev/null; then
  echo "OK - proceso sfcc-dev-mcp vivo"
else
  echo "AVISO - proceso no visible."
  echo "  OpenCode lo arranca solo al iniciar; VSCode al usarlo (Output -> MCP)."
  echo "  RECUERDA: MCP apagado = tool calling falla EN SILENCIO."
fi

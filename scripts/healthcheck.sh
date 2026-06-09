#!/usr/bin/env bash
# Verifica que todo el stack está vivo antes de pelearte con VSCode.
set -uo pipefail
LM_URL="${LM_URL:-http://localhost:1234}"

echo "== 1/3 LM Studio =="
if curl -sf "$LM_URL/v1/models" > /tmp/lms_models.json; then
  echo "OK - servidor respondiendo en $LM_URL"
  echo "Modelos cargados:"
  grep -o '"id":"[^"]*"' /tmp/lms_models.json | sed 's/"id":/  - /; s/"//g'
else
  echo "FALLO - LM Studio no responde. Developer -> Start Server."
fi

echo "== 2/3 Generacion =="
RESP=$(curl -sf "$LM_URL/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d '{"messages":[{"role":"user","content":"di OK"}],"max_tokens":5}' || true)
if [[ -n "$RESP" ]]; then echo "OK - el modelo genera tokens"; else echo "FALLO - el modelo no genera (¿cargado?)"; fi

echo "== 3/3 MCP (sfcc-dev) =="
if pgrep -f "sfcc-dev-mcp" > /dev/null; then
  echo "OK - proceso sfcc-dev-mcp vivo"
else
  echo "AVISO - no veo el proceso sfcc-dev-mcp."
  echo "  Si usas .vscode/mcp.json, VSCode lo arranca al usarlo (revisa Output -> MCP)."
  echo "  Para arrancarlo a mano: ./scripts/run-sfcc-coder.sh"
  echo "  RECUERDA: MCP apagado = tool calling falla EN SILENCIO."
fi

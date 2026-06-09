# 04 — Integración en VSCode (y OpenCode)

## Mapa de piezas

| Función | Extensión | Modelo |
|---|---|---|
| Chat agéntico + tools MCP | Copilot Chat (BYOK) | Qwen3-Coder-Next 80B |
| Inline/tab completions | Continue o Twinny | Qwen2.5-Coder 3B/7B |

**Importante:** Copilot Chat BYOK NO cubre inline completions — solo el chat. Por eso hacen falta dos extensiones. No es un bug de tu setup.

## Copilot Chat BYOK

1. Copilot Chat → icono de modelo → *Manage Models* → provider OpenAI-compatible
2. URL: `http://localhost:1234/v1` · API key: cualquier cosa · Model ID: el del 80B en LM Studio
3. En el chat, selecciona el modelo local y el modo *Agent* para que use las tools MCP

## MCP en VSCode

`.vscode/mcp.json` (en este repo) se activa al abrir el workspace. VSCode arranca el proceso bajo demanda. Verifica en Output → MCP que arrancó sin errores.

## Continue (autocomplete)

Copia `config/continue-config.example.yaml` a `~/.continue/config.yaml` y ajusta el model ID. Twinny es la alternativa más minimalista si Continue te parece pesado.

## OpenCode (alternativa de terminal)

- Config en `opencode.json` (raíz del repo): provider LM Studio + MCP sfcc-dev
- `agents.md` define el comportamiento del agente — **solo OpenCode lo lee; en VSCode no tiene ningún efecto**
- Útil para tareas largas tipo "refactoriza este cartridge" sin bloquear el editor

## Consideraciones corporativas

- La inferencia es 100% local: el código nunca sale de la máquina
- Lo que SÍ puede salir: telemetría de VSCode/extensiones de terceros → revisa settings de telemetría antes de usarlo con código del cliente
- Si LM Studio sirve en red local, restríngelo (firewall) en la oficina

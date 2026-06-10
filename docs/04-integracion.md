# 04 — Integración: OpenCode y VSCode

## Mapa de piezas

| Función | Herramienta | Modelo | Estado |
|---|---|---|---|
| Agente (validado) | **OpenCode** | sfcc-coder (80B) | ✅ tool calling verificado |
| Chat agéntico en editor | Copilot Chat (BYOK) | sfcc-coder | URL Ollama |
| Inline completions | Continue o Twinny | Qwen2.5-Coder 7B | pendiente de montar |

## OpenCode (ruta validada)

- Config: `opencode.json` (provider Ollama + MCP). OpenCode **arranca el MCP él solo**.
- `agents.md` en la raíz del proyecto = system prompt del agente con las reglas SFRA. **Solo OpenCode lo lee.** Sesión nueva tras editarlo.
- Verificación de tools: la llamada debe ser VISIBLE en la interfaz (p. ej. `sfcc-dev_get_sfcc_class_info [className=..., includeMethods=true]`). Respuesta sin tool call visible = está tirando de memoria.
- Contexto: `/compact` para resumir sesión; sesión nueva por tarea.

## VSCode

- **Chat**: Copilot Chat → Manage Models → OpenAI-compatible → `http://localhost:11434/v1`, model `sfcc-coder`. Modo **Agent**.
- **MCP**: `.vscode/mcp.json`, clave `"servers"`. VSCode lo arranca al usarlo; estado en Output → MCP.
- **Inline completions**: BYOK no las cubre → Continue (`config/continue-config.example.yaml`, apuntando a Ollama) o Twinny. Continue además trae `@codebase` (RAG local sobre tu proyecto).
- Las reglas de agents.md NO aplican en VSCode — equivalente: instrucciones de workspace de Copilot (`.github/copilot-instructions.md`), pendiente de portar.

## Usarlo en un proyecto SFCC real

Copia a la raíz del proyecto (p. ej. el clone de SFRA): `opencode.json`, `agents.md`, `.vscode/mcp.json`. El repo sfcc-coder es la herramienta; el proyecto SFCC es el trabajo.

## Consideraciones corporativas

- Inferencia 100% local; lo que puede salir es telemetría de VSCode/extensiones → revisar antes de usar con código de cliente.
- Ollama escucha solo en localhost por defecto; no lo expongas en red en la oficina sin pensarlo.

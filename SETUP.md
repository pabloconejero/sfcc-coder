# SETUP — de cero a funcionando

Ruta validada de principio a fin. La mayoría del tiempo es descargar el modelo.

## 0. Requisitos

- GPU NVIDIA (referencia: RTX 5080 16GB) + 32GB RAM
- [Ollama](https://ollama.com) (runtime) — `winget install Ollama.Ollama`
- Node.js ≥ 18 (MCP server)
- [OpenCode](https://opencode.ai) y/o VSCode + Copilot Chat (BYOK)
- Opcional: LM Studio solo como gestor de descargas de GGUF

## 1. Conseguir el modelo

Busca el GGUF **Qwen3-Coder-Next-80B-A3B UD-Q3_K_S de unsloth** (~34-36GB). Las variantes UD (Unsloth Dynamic) dan mejor calidad que el Q3_K_S plano a tamaño similar. NO uses Q4_K_M con 32GB de RAM (no cabe) ni variantes IQ3 (degradan más).

Vías: descargarlo con LM Studio (luego está en `~\.lmstudio\models`) o directo de Hugging Face.

## 2. Crear el modelo en Ollama

1. Edita el `FROM` del `Modelfile` (raíz del repo) con la ruta a tu GGUF
2. `ollama create sfcc-coder -f Modelfile`
3. Variables de entorno (PowerShell, luego reinicia Ollama desde la bandeja):

```powershell
[Environment]::SetEnvironmentVariable("OLLAMA_KEEP_ALIVE", "-1", "User")
[Environment]::SetEnvironmentVariable("OLLAMA_FLASH_ATTENTION", "1", "User")
[Environment]::SetEnvironmentVariable("OLLAMA_KV_CACHE_TYPE", "q8_0", "User")
```

4. Benchmark: `ollama run sfcc-coder --verbose` + prompt largo → **eval rate ~48 tok/s** esperado. `ollama ps` debe decir `Forever` y un reparto tipo 58%/42% CPU/GPU. Detalles y umbrales en `config/ollama.md`.

## 3. MCP server (sfcc-dev-mcp)

- Con OpenCode: **no hagas nada** — lo arranca él según `opencode.json`.
- Con VSCode: lo arranca el workspace vía `.vscode/mcp.json`; manualmente sería `npx -y sfcc-dev-mcp`.
- Modos: con `dw.json` (plantilla: `dw.json.example`) accede a sandbox; sin él, **docs-only** (suficiente para empezar).
- ⚠️ MCP apagado = tool calling falla EN SILENCIO. `scripts/healthcheck.sh` lo verifica.

## 4. OpenCode (ruta validada)

```powershell
irm https://opencode.ai/install.ps1 | iex
cd <este-repo-o-tu-proyecto-sfcc>
opencode
```

- `/models` → `ollama/sfcc-coder` si no lo coge solo
- `agents.md` en la raíz = reglas del agente (se lee al arrancar; sesión nueva tras editarlo)
- Prueba de fuego: *"¿Qué métodos tiene dw.catalog.ProductMgr? Consulta las tools del MCP"* → debes VER la tool call (`sfcc-dev_get_sfcc_class_info ...`) antes de la respuesta

## 5. VSCode

- Copilot Chat → Manage Models → provider OpenAI-compatible → URL `http://localhost:11434/v1`, model `sfcc-coder`, API key cualquiera
- Modo **Agent** (Ask no usa tools) · MCP en Output → MCP
- `.vscode/mcp.json` usa la clave **`"servers"`** (no `"mcpServers"`, eso es Cursor)
- Inline completions: Copilot BYOK no las cubre → Continue/Twinny con un Qwen2.5-Coder 7B (`ollama pull qwen2.5-coder:7b`), config en `config/continue-config.example.yaml`

## 6. Gestión de contexto en sesiones agénticas

Coste fijo por sesión (system + tools + agents.md): ~10-12K tokens. Con 64K quedan ~52K útiles. Hábitos: sesión nueva por tarea, `/compact` si se alarga, `ollama stop` al modelo FIM antes de sesiones largas.

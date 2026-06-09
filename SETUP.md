# SETUP — de cero a funcionando

Guía paso a paso. Tiempo estimado: 1-2h (la mayoría es descargar modelos).

## 0. Requisitos

- Windows / Linux con GPU NVIDIA (probado: RTX 5080 16GB) y 32GB RAM
- [LM Studio](https://lmstudio.ai) (runtime principal)
- [VSCode](https://code.visualstudio.com) + extensión **GitHub Copilot Chat** (modo BYOK)
- Node.js ≥ 18 (para el MCP server)
- Opcional: [OpenCode](https://opencode.ai) como agente de terminal alternativo

## 1. Descargar los modelos

En LM Studio, busca y descarga:

| Modelo | Cuantización | Rol |
|---|---|---|
| `Qwen3-Coder-Next-80B-A3B` | **Q3_K_S** | Chat / agéntico |
| `Qwen2.5-Coder-7B` (o 3B si vas justo de RAM) | Q4_K_M | Tab-completion (FIM) |

> ¿Por qué Q3_K_S en el grande? Es el punto dulce para que los expertos quepan en 32GB de RAM dejando hueco al SO. Más cuantización degrada notablemente; menos no cabe.

## 2. Configurar LM Studio (CRÍTICO)

Los defaults de LM Studio **infrarrinden gravemente**. Para el modelo 80B:

| Ajuste | Valor | Por qué |
|---|---|---|
| Context Length | **32768** | Agentes consumen 8-12K solo en system prompt + tools |
| GPU Offload | **Máximo** | Capas de atención a GPU |
| Force expert weights to CPU | **ON** | Los expertos del MoE van a RAM — es lo que hace viable un 80B en 16GB de VRAM |
| CPU Thread Pool | **8** | Óptimo en el 9800X3D |
| Flash Attention | ON | |

Resultado esperado: **~35 tok/s**. Si ves <10 tok/s, revisa GPU offload (ver [troubleshooting](docs/05-troubleshooting.md)).

Activa el servidor local: **Developer → Start Server** (por defecto `http://localhost:1234/v1`). Carga ambos modelos (LM Studio soporta multi-model serving).

## 3. MCP server (sfcc-dev-mcp)

Es la pieza que le da al modelo conocimiento real de SFCC: documentación de clases dw.*, best practices SFRA, logs, y acceso a sandbox.

```bash
# Con credenciales de sandbox:
npx sfcc-dev-mcp --dw-json /ruta/a/dw.json

# Sin credenciales (modo docs-only, perfecto para empezar o para el portátil del trabajo):
npx sfcc-dev-mcp
```

O usa el script: `./scripts/run-sfcc-coder.sh` (lee `dw.json` si existe, si no arranca docs-only).

> ⚠️ **Si el MCP server no está arrancado, las tools fallan EN SILENCIO.** El modelo simplemente responderá de memoria sin consultar nada. Fue la causa raíz del "no usa herramientas" en las primeras pruebas. Verifica con `./scripts/healthcheck.sh`.

## 4. VSCode

### 4a. Chat agéntico (Copilot Chat BYOK)

1. Abre Copilot Chat → Manage Models → añade provider OpenAI-compatible
2. Endpoint: `http://localhost:1234/v1` — Modelo: el ID del Qwen3-Coder-Next en LM Studio
3. API key: cualquier string (LM Studio no la valida)

### 4b. MCP

El fichero `.vscode/mcp.json` de este repo ya está listo. Recuerda:

```jsonc
{
  "servers": {        // ← "servers", NO "mcpServers" (eso es Cursor)
    ...
  }
}
```

### 4c. Inline completions (tab)

Copilot Chat BYOK **no cubre** inline completions. Instala **Continue** (o Twinny) y apunta su modelo de autocomplete al Qwen2.5-Coder pequeño en `http://localhost:1234/v1`. Ver config de ejemplo en `config/continue-config.example.yaml`.

## 5. OpenCode (opcional)

`opencode.json` en la raíz ya apunta a LM Studio y al MCP. Notas:

- `agents.md` es **específico de OpenCode** — VSCode lo ignora.
- Sin sandbox, omite `--dw-json` para modo docs-only.

## 6. Verificación final

```bash
./scripts/healthcheck.sh
```

Comprueba: LM Studio respondiendo, ambos modelos cargados, MCP server vivo. Luego en VSCode pregunta algo tipo: *"¿Qué métodos tiene dw.catalog.ProductMgr? Usa las tools del MCP"* — debes ver la llamada a la tool en el chat.

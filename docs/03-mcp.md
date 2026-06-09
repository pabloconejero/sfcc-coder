# 03 — MCP y sfcc-dev-mcp

## Qué es MCP en 3 líneas

Model Context Protocol: un estándar para exponer "tools" (funciones) a un LLM. El cliente (VSCode, OpenCode) arranca un proceso servidor, le pregunta qué tools tiene, y se las describe al modelo. Cuando el modelo "llama" a una tool, el cliente ejecuta la llamada contra el servidor y devuelve el resultado.

## sfcc-dev-mcp (taurgis)

Dependencia de primera clase de este proyecto. Aporta tools de:

- Documentación de clases `dw.*` y SFRA
- Best practices (cartridges, hooks, ISML, jobs, SCAPI...)
- Acceso a sandbox: logs, system objects, code versions (requiere `dw.json`)

## Dos modos

| Modo | Cómo | Cuándo |
|---|---|---|
| Completo | `npx sfcc-dev-mcp --dw-json ./dw.json` | Tienes sandbox |
| **Docs-only** | `npx sfcc-dev-mcp` (sin `--dw-json`) | Sin credenciales — portátil del trabajo, aprendizaje |

`scripts/run-sfcc-coder.sh` elige el modo automáticamente según exista `dw.json`.

## Los dos fallos clásicos

### 1. La clave del JSON en VSCode

```jsonc
// .vscode/mcp.json — CORRECTO (VSCode)
{ "servers": { ... } }

// INCORRECTO — esto es formato Cursor y VSCode lo ignora sin avisar
{ "mcpServers": { ... } }
```

El #1 error de setup al copiar configs de blogs/repos pensados para Cursor o Claude Desktop.

### 2. Servidor apagado = fallo silencioso

Si el proceso MCP no está vivo, el modelo no recibe las tools y responde de memoria, sin error visible. Diagnóstico: `./scripts/healthcheck.sh` y el panel Output → MCP de VSCode.

## Seguridad

`dw.json` contiene credenciales reales → está en `.gitignore`. Nunca lo subas. Usa `dw.json.example` como plantilla.

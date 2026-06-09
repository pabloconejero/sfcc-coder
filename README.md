# sfcc-coder

Asistente de código IA **100% local** especializado en **Salesforce B2C Commerce Cloud (SFCC / SFRA)**.

El objetivo: tener tu propio "Claude Code" corriendo en tu máquina, integrado en VSCode (y opcionalmente OpenCode), con conocimiento profundo de SFCC vía MCP — sin que ni una línea de código salga de tu equipo.

## ¿Qué cubre?

- Desarrollo SFRA (controllers, models, ISML, client-side JS)
- OCAPI / SCAPI
- Business Manager y configuración
- Job Framework
- OMS e integraciones
- Services framework y DevOps (sgmf, cartridges, code versions)

## Arquitectura (resumen)

```
┌─────────────────────────────────────────────────┐
│  VSCode                                         │
│  ├─ Copilot Chat (BYOK) ──► LM Studio (chat)    │
│  ├─ Continue/Twinny ──────► LM Studio (FIM)     │
│  └─ MCP (.vscode/mcp.json) ─► sfcc-dev-mcp      │
└─────────────────────────────────────────────────┘

LM Studio sirve DOS modelos:
  1. Qwen3-Coder-Next 80B-A3B (Q3_K_S) → chat/agéntico  (~35 tok/s)
  2. Qwen2.5-Coder 3B/7B               → tab-completion (FIM)
```

Estrategia **dual-model**: un MoE grande para razonar y usar herramientas, un modelo pequeño y denso para autocompletado instantáneo. Un solo modelo para todo no funciona: el 80B es demasiado lento para FIM.

## Hardware de referencia

| Componente | Mínimo probado |
|---|---|
| GPU | RTX 5080 16GB (atención en GPU) |
| RAM | 32GB (expertos del MoE en CPU — va al ~99%, ver troubleshooting) |
| CPU | Ryzen 7 9800X3D (8 threads para inferencia) |

## Quickstart

1. Lee [`SETUP.md`](SETUP.md) — instalación paso a paso.
2. Arranca LM Studio con la config de [`config/lmstudio.md`](config/lmstudio.md).
3. Arranca el MCP server: `./scripts/run-sfcc-coder.sh` ⚠️ **si el MCP no está corriendo, el tool calling falla en silencio**.
4. Abre VSCode en este repo: `.vscode/mcp.json` ya está configurado.

## Documentación / ruta de aprendizaje

| Doc | Qué aprenderás |
|---|---|
| [docs/01-arquitectura.md](docs/01-arquitectura.md) | Por qué este diseño: dual-model, MoE con offload híbrido, MCP |
| [docs/02-modelos.md](docs/02-modelos.md) | Cuantización, contexto, GPU offload — y por qué los defaults te sabotean |
| [docs/03-mcp.md](docs/03-mcp.md) | Qué es MCP, cómo funciona sfcc-dev-mcp, modo docs-only |
| [docs/04-integracion-vscode.md](docs/04-integracion-vscode.md) | BYOK, inline completions, diferencias con OpenCode |
| [docs/05-troubleshooting.md](docs/05-troubleshooting.md) | Los errores que ya cometimos para que no los repitas |
| [docs/06-roadmap.md](docs/06-roadmap.md) | Evals, fine-tuning, servidor de inferencia corporativo |

## Errores #1 (léelos antes de tocar nada)

1. **`.vscode/mcp.json` usa la clave `"servers"`**, no `"mcpServers"` (eso es formato Cursor). Es el fallo de setup más común al copiar configs de internet.
2. **Contexto por defecto = muerte.** Ollama arranca a 4096 tokens; el system prompt + definiciones de tools de un agente se lo comen entero. Mínimo viable: 16K, recomendado 32K.
3. **MCP server apagado = el modelo "no usa herramientas"** sin dar ningún error. Compruébalo siempre primero (`scripts/healthcheck.sh`).

## Licencia

MIT — ver [LICENSE](LICENSE).

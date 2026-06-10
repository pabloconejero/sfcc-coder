# sfcc-coder

Asistente de código IA **100% local** especializado en **Salesforce B2C Commerce Cloud (SFCC / SFRA)**.

Tu propio "Claude Code" corriendo en tu máquina, integrado en OpenCode y VSCode, con conocimiento real de SFCC vía MCP — sin que ni una línea de código salga de tu equipo.

**Estado: stack completo validado.** Modelo 80B local a **48 tok/s**, contexto **64K**, tool calling funcionando contra `sfcc-dev-mcp`, agente con reglas SFRA en `agents.md`.

## ¿Qué cubre?

Desarrollo SFRA (controllers, models, ISML, client-side), OCAPI/SCAPI, Business Manager, Job Framework, OMS, Services y DevOps.

## Arquitectura

```
┌──────────────────────────────────────────────────────┐
│  OpenCode / VSCode                                   │
│  ├─ Chat agéntico ────► Ollama (sfcc-coder, 80B)     │
│  ├─ Continue/Twinny ──► Ollama (Qwen2.5-Coder, FIM)  │
│  ├─ agents.md ────────  reglas SFRA del agente       │
│  └─ MCP ──────────────► sfcc-dev-mcp (docs/sandbox)  │
└──────────────────────────────────────────────────────┘
```

- **Runtime: Ollama** (`http://localhost:11434/v1`). LM Studio quedó relegado a gestor de descargas tras la comparativa medida (9 vs 48 tok/s — historia en troubleshooting).
- **Dual-model**: 80B MoE para razonar/agente; modelo pequeño denso para tab-completion.
- **Conocimiento SFCC**: el modelo NO lo tiene (alucina con seguridad — ver `evals/baseline-sin-tools.md`); lo aporta el MCP en cada consulta.

## Config validada (hardware de referencia)

| | |
|---|---|
| Hardware | R7 9800X3D · RTX 5080 16GB · 32GB RAM |
| Modelo | Qwen3-Coder-Next 80B-A3B **UD-Q3_K_S** (unsloth) |
| Contexto | **65536** (KV cache q8_0 + flash attention) |
| Reparto | 58% CPU (expertos) / 42% GPU (atención + KV) |
| Rendimiento | **48.19 tok/s** · CPU ~60°C · sin swap |

## Quickstart

1. [`SETUP.md`](SETUP.md) — instalación paso a paso (Ollama + MCP + OpenCode/VSCode)
2. `Modelfile` (raíz) — config del modelo lista para `ollama create`
3. `agents.md` — las reglas SFRA del agente (se copia a cada proyecto de trabajo)
4. ⚠️ Los tres fallos silenciosos clásicos: MCP apagado, contexto por defecto, desbordamiento de VRAM → [troubleshooting](docs/05-troubleshooting.md)

## Documentación

| Doc | Contenido |
|---|---|
| [docs/01-arquitectura.md](docs/01-arquitectura.md) | Por qué este diseño: dual-model, MoE híbrido, MCP vs fine-tuning |
| [docs/02-modelos.md](docs/02-modelos.md) | Cuantización (UD), contexto, KV cache, offload — y cómo los defaults sabotean |
| [docs/03-mcp.md](docs/03-mcp.md) | MCP, sfcc-dev-mcp, modo docs-only, fallos silenciosos |
| [docs/04-integracion.md](docs/04-integracion.md) | OpenCode (validado), VSCode BYOK, Continue, agents.md |
| [docs/05-troubleshooting.md](docs/05-troubleshooting.md) | La saga completa: 9 → 48 tok/s, diagnóstico paso a paso |
| [docs/06-roadmap.md](docs/06-roadmap.md) | Evals, fine-tuning, servidor corporativo |

## Uso en un proyecto SFCC real

Copia a la raíz del proyecto (p. ej. tu clone de SFRA): `opencode.json`, `agents.md` y `.vscode/mcp.json`. Abre OpenCode ahí y el agente tendrá modelo + MCP + reglas.

## Licencia

MIT.

# 02 — Modelos: cuantización, contexto y memoria

## Por qué los defaults sabotean

1. **Contexto por defecto minúsculo** (Ollama: 4096). El coste fijo de un agente (system prompt + tools MCP + agents.md) son ~10-12K tokens — con el default, el modelo ni ve tu pregunta. Mínimo 16K; validado y recomendado: **65536** con KV cuantizado.
2. **Reparto de memoria mal hecho** → desbordamiento de VRAM silencioso (la saga completa en docs/05). Ollama lo calcula bien automáticamente; con sliders manuales, la regla: caber sin desbordar gana siempre a meter más capas.

## Cuantización: UD-Q3_K_S

Con 32GB de RAM para los expertos del 80B:

| Quant | ¿Cabe? | Notas |
|---|---|---|
| Q4_K_M (~46GB) | No | Swap mortal |
| **UD-Q3_K_S (unsloth, ~35GB)** | **Sí** | **La elegida: Unsloth Dynamic cuantiza por capas según sensibilidad → mejor calidad que Q3_K_S plano a tamaño similar** |
| Q3_K_S plano | Sí | Alternativa válida |
| IQ3_* / Q2 | Sí | Degradación notable — evitar |

Con 64GB de RAM: sube a Q4_K_M.

El peaje del Q3: pérdida de precisión factual fina (firmas exactas de métodos). Por diseño no importa: **los hechos los aporta el MCP; el modelo pone el razonamiento.**

## Contexto y KV cache

El contexto vive en el **KV cache**, que para las capas en GPU reside en VRAM. En este setup (expertos en RAM) la VRAM va holgada → ampliar contexto es barato:

- `OLLAMA_KV_CACHE_TYPE=q8_0` → cache a mitad de memoria, pérdida despreciable (requiere `OLLAMA_FLASH_ATTENTION=1`)
- Resultado medido: 64K de contexto, reparto 58/42 CPU/GPU (~14.3GB de VRAM usados de 16), sin swap, 48 tok/s

Presupuesto de sesión agéntica: ~10-12K de coste fijo + variable por turno → ~52K útiles. Hábitos: sesión por tarea, `/compact` al alargarse.

## El modelo FIM

Tab-completion necesita un modelo con **Fill-In-the-Middle** y latencia <300ms → Qwen2.5-Coder 3B/7B (`ollama pull qwen2.5-coder:7b`). El 80B jamás servirá para esto (latencia), y el 7B jamás para razonar un refactor — por eso dual-model. `ollama stop` al FIM antes de sesiones agénticas largas para liberar memoria.

## Benchmark casero (hazlo tras CADA cambio de config)

`ollama run sfcc-coder --verbose` + el mismo prompt largo siempre (el del controller de FAQ). Métrica: **eval rate** con 400+ tokens generados. Referencia: 48 tok/s. Vigila también disco (swap) y `ollama ps` (reparto).

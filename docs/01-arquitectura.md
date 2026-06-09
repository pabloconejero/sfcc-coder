# 01 — Arquitectura

## El problema

Queremos la experiencia de Claude Code (agente que lee código, llama tools, edita ficheros, conoce SFCC) pero 100% local, en hardware de consumo, para uso en entorno corporativo.

## Las tres decisiones clave

### 1. Dual-model en vez de un modelo para todo

Dos cargas de trabajo con requisitos opuestos:

| Workload | Necesita | Tolera |
|---|---|---|
| Chat agéntico | Razonamiento, tool calling fiable, contexto largo | Latencia de segundos |
| Tab-completion (FIM) | Latencia <300ms | Modelo "tonto" |

Un MoE de 80B con expertos en CPU jamás dará latencias de FIM. Un 7B jamás razonará un refactor de controller SFRA. Solución: **dos modelos servidos a la vez** por LM Studio.

### 2. MoE + offload híbrido: cómo cabe un 80B en 16GB de VRAM

Qwen3-Coder-Next es 80B-A3B: 80B parámetros totales pero solo ~3B *activos* por token (Mixture of Experts). Esto permite:

- **Atención y capas compartidas → GPU** (lo que se ejecuta siempre, lo crítico para velocidad)
- **Expertos → RAM/CPU** (solo se consulta un subconjunto por token)

Resultado: calidad de modelo grande a ~35 tok/s en hardware de consumo. El coste: RAM al límite (99% con 32GB).

### 3. Conocimiento SFCC vía MCP, no vía fine-tuning (por ahora)

El modelo base no conoce bien las APIs dw.* ni las best practices SFRA actuales. Dos vías:

- **MCP (elegida)**: `sfcc-dev-mcp` expone docs, best practices y sandbox como tools. Conocimiento siempre actualizado, cero entrenamiento.
- **Fine-tuning (futuro)**: LoRA sobre un 80B MoE es muy caro en recursos; si llega, será sobre un modelo denso pequeño. Ver roadmap.

## Flujo de una petición agéntica

1. Escribes en Copilot Chat: "crea un endpoint SCAPI custom para wishlist"
2. VSCode envía el prompt + definiciones de tools MCP a LM Studio
3. El modelo decide llamar a una tool del MCP (p.ej. buscar docs de SCAPI hooks)
4. VSCode ejecuta la tool contra sfcc-dev-mcp y devuelve el resultado al modelo
5. El modelo genera el código con la información real

El punto 3-4 es donde todo se rompe en silencio si el MCP no está vivo o el contexto es demasiado pequeño para las definiciones de tools.

## Escalado futuro: del portátil al servidor

Para portátiles corporativos sin GPU: un **servidor de inferencia centralizado** (vLLM o sglang) sirviendo el mismo endpoint OpenAI-compatible. Los clientes solo cambian la URL en su config. Ver docs/06-roadmap.md.

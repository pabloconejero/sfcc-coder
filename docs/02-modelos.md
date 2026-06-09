# 02 — Modelos: cuantización, contexto y offload

## Por qué los defaults te sabotean

Las dos causas raíz de "el modelo local es malo" casi nunca son el modelo:

1. **Contexto por defecto minúsculo.** Ollama arranca en 4096 tokens. El system prompt de un agente (OpenCode, Copilot) + las definiciones de tools MCP consumen 8-12K. Con 4K, el modelo ni siquiera ve tu pregunta completa y el output se degrada de forma rara (respuestas cortadas, tools ignoradas). **Mínimo viable: 16K. Recomendado: 32K.**

2. **GPU offload bajo por defecto.** LM Studio a veces arranca con pocas capas en GPU. Síntoma: <10 tok/s. Solución: offload al máximo + expertos a CPU explícitamente.

## Cuantización: por qué Q3_K_S

Con 32GB de RAM para los expertos del 80B:

| Quant | ¿Cabe? | Calidad |
|---|---|---|
| Q4_K_M | No (swap constante) | — |
| **Q3_K_S** | **Justo (~99% RAM)** | **Buena para código** |
| Q2_K | Sí, holgado | Degradación notable en razonamiento |

Con 64GB de RAM, sube a Q4_K_M sin dudarlo.

## El modelo FIM

Para tab-completion necesitas un modelo entrenado en **Fill-In-the-Middle** (rellena código entre un prefijo y un sufijo). Qwen2.5-Coder lo soporta nativamente. Criterio 3B vs 7B:

- **7B** si te cabe en la VRAM sobrante junto a la atención del 80B → mejor calidad
- **3B** si vas justo → sigue siendo perfectamente útil para completions de una línea

## Benchmark casero

Tras cualquier cambio de config, mide tok/s con el mismo prompt largo (LM Studio lo muestra). Referencia en este hardware: ~35 tok/s en el 80B. Si bajas de 20, algo se ha desconfigurado.

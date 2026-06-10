# 05 — Troubleshooting (errores reales, diagnósticos reales)

Metodología: **medir → causa raíz → arreglar → re-medir.** Casi ningún problema de calidad o velocidad fue del modelo.

## La saga: de 9 a 48 tok/s en una tarde (caso de estudio)

Mismo hardware, mismo GGUF. Cronología real:

1. **LM Studio, config a medias → 9.89 tok/s.** Síntomas: GPU al 80-90% "ocupada", disco al 1%, CPU 50-60%.
2. **Diagnóstico**: GPU alta + MoE que debería tener expertos en CPU = sospechoso. Causa raíz: "layers to force to CPU" quedó en 10 de 48 → los expertos restantes desbordaron los 16GB de VRAM → el driver NVIDIA activó su *fallback* silencioso a RAM por PCIe. La GPU aparece ocupada pero está esperando transferencias, no calculando. **Utilización alta ≠ trabajo útil.**
3. **Segundo problema**: el slider de threads de LM Studio capado a 4 (el 9800X3D tiene 8 núcleos).
4. **Cambio a Ollama** (reparto automático + `num_thread 8`) → **46 tok/s**. `ollama ps`: 58%/42% CPU/GPU, GPU al 28% a ráfagas (¡y 5x más rápido que al 85%!).
5. **Contexto 32K → 64K** con KV cache q8_0 + flash attention → **48.19 tok/s**, sin swap, CPU a 60°C.

### Reglas destiladas

- **Pocas capas en GPU sin desbordamiento > muchas con desbordamiento. Siempre.** El rendimiento vs offload no es una curva suave: tiene un precipicio en el punto de desbordamiento.
- Detectar el desbordamiento: Admin. de tareas → GPU → "Memoria GPU compartida" con varios GB usados durante la generación = estás en el fallback.
- Prevención: Panel NVIDIA → CUDA Sysmem Fallback Policy → "Prefer No Sysmem Fallback" para el runtime → error explícito en vez de degradación muda.
- Benchmarks solo con generaciones largas (400+ tokens); 12 tokens miden el overhead de arranque, no la velocidad.

## "El modelo no usa las herramientas MCP"

1. ¿Proceso MCP vivo? (`scripts/healthcheck.sh`) — **fallo silencioso clásico #1**
2. ¿`"servers"` (no `"mcpServers"`) en `.vscode/mcp.json`?
3. ¿Contexto suficiente? El coste fijo de agente son ~10-12K; con 4-8K las tools se truncan
4. ¿Modo Agent en Copilot Chat? (Ask no usa tools)
5. En OpenCode: ¿la tool call es visible en la interfaz? Si responde sin tool call visible, está tirando de memoria

## "Va lento" (<20 tok/s)

- Desbordamiento de VRAM (ver saga) — revisa memoria GPU compartida
- Threads: en Ollama, `num_thread 8` en el Modelfile; en LM Studio el slider puede estar capado por detección errónea de hardware
- Swap: disco activo durante generación → baja contexto o cierra apps
- Dos modelos grandes cargados a la vez → `ollama stop` al que no uses

## "El modelo alucina APIs de SFCC"

Esperado **a pelo**: SFCC es nicho y el modelo rellena huecos con seguridad (ver `evals/baseline-sin-tools.md` — un ejemplo real con `routes.json` y tags ISML inventados que parece código senior). Mitigación por capas:
1. MCP conectado + instrucción de consultarlo (agents.md) — la principal
2. Sampling conservador (temperature 0.7 o menos para código, ya en el Modelfile)
3. System prompt con "si no estás seguro, dilo"
4. Suelo irreducible: cuantización Q3 pierde precisión factual — por eso los hechos vienen del MCP, el modelo pone el razonamiento

## "Genera código que funciona pero no es idiomático SFRA"

Copia ficheros enteros en vez de extender, rutas absolutas en vez de `*` o alias... → no es problema de modelo, es de reglas: `agents.md` las codifica (superModule, imports `*` server-side, alias/`./` client-side). Cada idiom nuevo violado → regla en agents.md + eval en `evals/prompts/`. Sesión nueva tras editar agents.md.

## "Se queda colgado al primer mensaje tras un rato"

No está colgado: keep-alive por defecto de 5 min descargó el 80B y está recargando. `OLLAMA_KEEP_ALIVE=-1` (ver config/ollama.md).

## "Copié una config de un blog y no funciona"

Cada cliente tiene su formato: VSCode (`servers`), Cursor/Claude Desktop (`mcpServers`), OpenCode (clave `mcp` en opencode.json). No son intercambiables.

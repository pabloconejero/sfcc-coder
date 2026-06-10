# LM Studio (relegado a herramienta secundaria)

Tras la comparativa medida (9 tok/s vs 48 en Ollama, mismo hardware y GGUF — ver docs/05), LM Studio dejó de ser el runtime. Sigue siendo útil para:

- **Descargar GGUF** con buena UI de búsqueda (los ficheros quedan en `~\.lmstudio\models` y se importan a Ollama vía Modelfile)
- Chatear rápido con un modelo para probarlo

## Por qué falló como runtime (en este hardware)

1. Slider de threads capado a 4 (detección errónea del 9800X3D)
2. "Layers to force to CPU" a medias → desbordamiento de VRAM silencioso vía fallback del driver NVIDIA
3. Sus avisos de memoria no contemplan el reparto expertos-a-CPU (falsos "too large" y falsos OK)

Si aun así lo usas: contexto 32768, GPU offload máximo, **force expert weights to CPU al máximo**, flash attention ON, y verifica "Memoria GPU compartida" ≈ 0 durante la generación.

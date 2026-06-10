# Configuración Ollama (runtime principal)

Validado: **48.19 tok/s** generando 1900 tokens, contexto 64K, CPU ~60°C, reparto 58/42 CPU/GPU, sin swap.

## 1. Importar el GGUF local

No re-descargues el modelo si ya lo tienes de LM Studio:

```powershell
dir "$env:USERPROFILE\.lmstudio\models" -Recurse -Filter *.gguf
```

Pon esa ruta en el `FROM` del `Modelfile` (raíz del repo) y:

```powershell
ollama create sfcc-coder -f Modelfile
```

## 2. Variables de entorno (las tres, y reinicia Ollama después)

```powershell
[Environment]::SetEnvironmentVariable("OLLAMA_KEEP_ALIVE", "-1", "User")        # no descargar el modelo tras 5 min (recargar el 80B es lento)
[Environment]::SetEnvironmentVariable("OLLAMA_FLASH_ATTENTION", "1", "User")    # requisito del KV cuantizado + ahorra memoria
[Environment]::SetEnvironmentVariable("OLLAMA_KV_CACHE_TYPE", "q8_0", "User")   # KV cache a mitad de memoria, pérdida despreciable -> permite 64K de contexto
```

Verificación: `ollama ps` debe mostrar `Forever` en la columna de expiración.

## 3. Benchmark

```powershell
ollama run sfcc-coder --verbose
```

Prompt de referencia: *"Escribe un controller SFRA completo para una página de FAQ con su modelo y comenta cada bloque"*. Mira **eval rate** (generación), no prompt eval rate. Referencia en este hardware: ~48 tok/s. Si <20, revisa troubleshooting.

## 4. API para integraciones

OpenAI-compatible, siempre activa, sin botón de arrancar: `http://localhost:11434/v1` — model ID: `sfcc-coder`.

## 5. Comandos útiles

```powershell
ollama ps          # modelo cargado, reparto CPU/GPU, expiración
ollama list        # modelos creados
ollama stop NAME   # descargar un modelo de memoria (ej. el FIM antes de una sesión agéntica larga)
ollama show sfcc-coder            # parámetros aplicados
ollama show sfcc-coder --template # plantilla de chat (debe ser ChatML)
```

## Por qué Ollama y no LM Studio

Medido en el mismo hardware, mismo modelo, mismo prompt: LM Studio 9 tok/s (threads capados a 4 + desbordamiento de VRAM silencioso) vs Ollama 46-48 tok/s (reparto automático correcto + 8 threads). Detalle completo en docs/05-troubleshooting.md. LM Studio sigue siendo útil como gestor de descargas de GGUF y para chatear rápido — ver config/lmstudio.md.

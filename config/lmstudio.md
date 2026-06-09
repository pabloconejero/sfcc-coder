# Configuración LM Studio (referencia rápida)

## Modelo principal: Qwen3-Coder-Next 80B-A3B (Q3_K_S)

| Ajuste | Valor |
|---|---|
| Context Length | 32768 |
| GPU Offload | Máximo |
| Force expert weights to CPU | ON |
| CPU Thread Pool Size | 8 |
| Flash Attention | ON |
| Keep model in memory | ON |

Rendimiento de referencia (RTX 5080 + 9800X3D + 32GB): **~35 tok/s**.

### Presión de RAM al ~99%

Es lo esperado con 32GB: los expertos del MoE viven en RAM. Si el sistema empieza a hacer swap o se congela:
- Reduce 1-2 capas de expertos en CPU (mueve alguna a GPU si queda VRAM)
- O baja el contexto a 24576
- Cierra Chrome antes de cargar el modelo (en serio)

## Modelo FIM: Qwen2.5-Coder 7B (Q4_K_M)

| Ajuste | Valor |
|---|---|
| Context Length | 8192 |
| GPU Offload | Máximo (cabe entero en VRAM junto a la atención del 80B; si no, usa el 3B) |

## Servidor

Developer → Start Server → `http://localhost:1234/v1`. Activa "serve on local network" SOLO si quieres acceder desde otra máquina (ojo en el trabajo).

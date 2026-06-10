# 06 — Roadmap

## ✅ Hecho
- Stack validado: Ollama + 80B UD-Q3_K_S a 48 tok/s, 64K ctx, MCP con tool calling verificado, OpenCode + agents.md con reglas SFRA
- Comparativa de runtimes medida (LM Studio descartado como runtime)
- Primeras 3 evals de idioms + baseline de alucinación documentado

## En curso
- Ciclo fallo → regla (agents.md) → eval: pendientes hooks OCAPI/SCAPI, Job Framework, servicios (LocalServiceRegistry), client-side por eventos
- Montar Continue para inline completions (qwen2.5-coder:7b)
- Portar reglas de agents.md a instrucciones de workspace de VSCode

## Siguiente
1. **Suite de evals completa** (50+ prompts, 7 dominios) y baseline numérico
2. **Sandbox**: dw.json + modo completo del MCP (logs, system objects, upload de cartridge)
3. **Fine-tuning** (solo si las evals demuestran que MCP+reglas no bastan): LoRA sobre denso pequeño, nunca sobre el 80B MoE
4. **Despliegue corporativo**: servidor central vLLM/sglang, mismo API → clientes cambian solo baseURL. Pendiente: auth, rate limiting, política de datos
5. **Empaquetado**: instalación one-shot, versiones pinneadas, CI que valide configs

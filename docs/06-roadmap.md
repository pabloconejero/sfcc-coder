# 06 — Roadmap

## 1. Baseline de evaluación (siguiente paso)

Ejecutar la suite de 50+ prompts en 7 dominios SFCC (SFRA, ISML, OCAPI/SCAPI, Business Manager, Job Framework, OMS, Services/DevOps) contra el setup actual. Objetivo: número de referencia para comparar modelos/configs objetivamente en vez de "a ojo". Estructura en `evals/`.

## 2. Fine-tuning (en evaluación)

- LoRA sobre el 80B MoE: muy caro en recursos, probablemente inviable en este hardware
- Plan más realista: fine-tune de un modelo **denso pequeño** (7-14B) con dataset SFCC, y medir contra el baseline si MCP + modelo grande sigue ganando
- Decisión guiada por las evals, no por hype

## 3. Despliegue corporativo

Los portátiles del trabajo no tienen GPU para esto. Arquitectura acordada:

- **Servidor de inferencia centralizado** con vLLM o sglang (mejor throughput multi-usuario que LM Studio)
- Mismo API OpenAI-compatible → los clientes solo cambian `baseURL`
- Pendiente: auth, rate limiting, y política de datos (el código viajaría al servidor interno — sigue sin salir de la empresa, pero ya no es on-device)

## 4. Empaquetado

- Script de instalación one-shot
- Pin de versiones (sfcc-dev-mcp, extensiones)
- CI básico que valide los JSON de config

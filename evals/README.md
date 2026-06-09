# Evals

Suite de evaluación para medir objetivamente la calidad del asistente en dominios SFCC.

## Dominios (7)

1. SFRA (controllers, models, client-side)
2. ISML templating
3. OCAPI / SCAPI
4. Business Manager / administración
5. Job Framework
6. OMS / integraciones
7. Services framework / DevOps

## Estructura

```
evals/
├── prompts/        # un .md por prompt: enunciado + criterios de aceptación
└── results/        # outputs por modelo/config (gitignored)
```

## Formato de prompt

```markdown
# [dominio] Título corto
## Prompt
(lo que se le pide al modelo)
## Criterios
- [ ] usa server.append en vez de reemplazar el controller
- [ ] consulta docs vía MCP antes de responder
- [ ] ...
```

## Cómo puntuar

De momento manual: ✅ / ⚠️ / ❌ por criterio. El baseline con Qwen3-Coder-Next + MCP es el primer paso del roadmap.

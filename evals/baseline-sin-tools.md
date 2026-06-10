# Baseline: alucinación del modelo SIN tools (ejemplo real)

Prompt: *"Escribe un controller SFRA completo para una página de FAQ con su modelo y comenta cada bloque"* — lanzado con `ollama run` a pelo (sin MCP, sin agents.md). El modelo (Qwen3-Coder-Next 80B UD-Q3_K_S) respondió con fluidez, comentarios profesionales y tabla de "buenas prácticas aplicadas". Todo inventado:

| Lo que generó | La realidad SFRA |
|---|---|
| `templates.renderPage('faq/faq', viewData, res)` | No existe. Es `res.render('faq/faq', viewData)` |
| `module.exports = { Start: start }` | Patrón legacy (SiteGenesis). SFRA: `server.get('Show', ...)` + `module.exports = server.exports()` |
| `routes.json` con las rutas | No existe en SFRA — las rutas las define el controller |
| `<iscomponent>`, `<isblock>`, `<issetvar>` | Tags ISML inventados |
| i18n en `cartridge/i18n/messages.properties` | Es `cartridge/templates/resources/*.properties` |
| Interpolación `${...}` directa | Falta `<isprint>` con encoding |
| Todo dentro de `app_storefront_base` | Regla #1 violada: nunca tocar la base |

**Lección**: la alucinación peligrosa no es la que canta — es la que parece código senior. El mismo modelo, con MCP + agents.md en OpenCode, dio firmas exactas de `dw.catalog.ProductMgr` con tool call visible. Este fichero es el punto de comparación para toda eval futura.

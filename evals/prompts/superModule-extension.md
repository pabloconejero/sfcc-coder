# [SFRA] Extender controller sin copiar la base

## Prompt
Extiende el controller Product-Show para añadir al viewData un flag `isNewArrival` si el producto se creó hace menos de 30 días. No modifiques app_storefront_base.

## Criterios
- [ ] `server.extend(module.superModule)` + `server.append('Show', ...)` — NO copia el fichero base
- [ ] Leyó el controller base antes de extender (tool call de lectura visible)
- [ ] `module.exports = server.exports()`
- [ ] Justifica si usara prepend/replace en vez de append

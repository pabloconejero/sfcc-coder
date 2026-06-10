# [SFRA] Resolución client-side: alias, relativo y SCSS

## Prompt
En mi cartridge custom, extiende el módulo client-side product/detail.js de la base para añadir un tracking al cambiar de variante, usando también un helper nuevo miTracking.js del propio cartridge. Añade el SCSS que importe productCard de la base.

## Criterios
- [ ] `var base = require('base/product/detail')` (alias de package.json) — NO copia el fichero ni usa ../../..
- [ ] `require('./miTracking')` para el helper local — NO alias
- [ ] Sobreescribe/añade funciones sobre `base` y termina con `module.exports = base`
- [ ] SCSS: `@import "~base/components/productCard";`
- [ ] Leyó la clave `paths` del package.json o el módulo base antes (tool call visible)

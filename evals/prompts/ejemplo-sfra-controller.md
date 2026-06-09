# [SFRA] Extender el controller Product-Show

## Prompt
Añade al PDP un bloque con el tiempo estimado de envío leído de un custom attribute del producto (`estimatedShippingDays`). No modifiques app_storefront_base.

## Criterios
- [ ] Crea cartridge custom y usa `server.append('Show', ...)` sobre `module.superModule`
- [ ] Lee el atributo vía `product.custom.estimatedShippingDays` con null-check
- [ ] Pasa el dato por el viewData, no por sesión
- [ ] ISML con `<isprint>` y encoding correcto
- [ ] Consultó docs/best practices vía MCP (visible en el trace de tools)

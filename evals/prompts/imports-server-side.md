# [SFRA] Imports server-side con asterisco

## Prompt
Crea un script en mi cartridge custom que use el productHelpers de la base y el ProductMgr para comprobar disponibilidad de un producto.

## Criterios
- [ ] `require('*/cartridge/scripts/helpers/productHelpers')` — nunca `require('app_storefront_base/...')`
- [ ] `require('dw/catalog/ProductMgr')` por nombre directo (excepción correcta)
- [ ] Verificó la firma de la API dw.* vía MCP (tool call visible)

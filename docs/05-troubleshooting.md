# 05 — Troubleshooting (errores que ya cometimos)

Metodología: **diagnostica la causa raíz antes de cambiar de modelo.** Casi todos los problemas de calidad fueron de configuración, no del modelo.

## "El modelo no usa las herramientas MCP"

1. ¿Está el proceso MCP vivo? → `./scripts/healthcheck.sh`. **Causa #1 histórica: el servidor no estaba arrancado y falla en silencio.**
2. ¿Clave correcta en `.vscode/mcp.json`? → `"servers"`, no `"mcpServers"`
3. ¿Contexto suficiente? Con 4-8K, las definiciones de tools se truncan y el modelo "no las ve"
4. ¿Modo Agent activado en Copilot Chat? El modo Ask no usa tools

## "Va lentísimo" (<10 tok/s)

- GPU Offload no está al máximo (default traicionero de LM Studio)
- Expertos NO están forzados a CPU → la GPU intenta paginar 40GB y muere
- Otro proceso comiendo VRAM (navegador con aceleración HW)

## "El PC se congela / swap constante"

RAM al 99% es lo normal; swap NO. Opciones:
- Baja contexto 32K → 24K
- Mueve 1-2 capas de expertos a GPU si sobra VRAM
- Cierra apps pesadas antes de cargar el modelo

## "Respuestas cortadas o incoherentes en OpenCode/agentes"

Contexto saturado. El system prompt + tools de OpenCode consumen casi 4K ellos solos — con el default de Ollama (4096) no queda sitio para nada. Sube a 16-32K.

## "El autocompletado tarda segundos"

Estás usando el 80B para FIM. No lo hagas: configura Continue/Twinny con el Qwen2.5-Coder pequeño.

## "Copiué la config de un blog y no funciona"

Comprueba para qué cliente era: Cursor (`mcpServers`), Claude Desktop (`mcpServers`), VSCode (`servers`), OpenCode (clave `mcp` en opencode.json). Los formatos NO son intercambiables.

#!/bin/bash
# Prepara REA (Reverse Engineer Anything) en cada sesión de Claude Code en la nube.
# Es idempotente: si algo ya está instalado, no lo vuelve a instalar.
set -euo pipefail

# Solo en sesiones remotas; en local lo instalas tú una vez.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

REA_VERSION="${REA_VERSION:-6.7.0}"
GHIDRA_HOME="${GHIDRA_HOME:-$HOME/.local/share/ghidra}"

# 1. CLI y servidor MCP de REA
if ! command -v rea >/dev/null 2>&1; then
  npm install --global "rea-agents@${REA_VERSION}" >/dev/null 2>&1
fi

# 2. Registro MCP en Claude Code + skill "reverse-engineer-anything"
if [ ! -f "$HOME/.claude/skills/reverse-engineer-anything/SKILL.md" ]; then
  rea setup --client claude_code --yes >/dev/null 2>&1 || true
fi

# 3. Ghidra (motor de desensamblado gratuito). Requiere JDK 21 y que la red
#    del entorno permita descargar desde GitHub. Define GHIDRA_URL con el .zip
#    de la release 12.1.x, p. ej.:
#    https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.1_build/ghidra_12.1_PUBLIC_<fecha>.zip
ghidra_dir="$(find "$GHIDRA_HOME" -maxdepth 1 -type d -name 'ghidra_12.1*' 2>/dev/null | head -1 || true)"
if [ -z "$ghidra_dir" ] && [ -n "${GHIDRA_URL:-}" ]; then
  mkdir -p "$GHIDRA_HOME"
  tmp_zip="$(mktemp --suffix=.zip)"
  if curl -fsSL "$GHIDRA_URL" -o "$tmp_zip"; then
    unzip -q "$tmp_zip" -d "$GHIDRA_HOME"
    ghidra_dir="$(find "$GHIDRA_HOME" -maxdepth 1 -type d -name 'ghidra_12.1*' | head -1)"
  else
    echo "Aviso: no se pudo descargar Ghidra desde $GHIDRA_URL" >&2
  fi
  rm -f "$tmp_zip"
fi

if [ -n "$ghidra_dir" ] && [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export GHIDRA_INSTALL_DIR=\"$ghidra_dir\"" >> "$CLAUDE_ENV_FILE"
fi

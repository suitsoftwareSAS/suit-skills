#!/bin/bash
# install-skills.sh - Instala skills según el agente de IA usado

SKILLS_REPO="https://github.com/suitsoftwareSAS/suit-skills.git"

# ─── Detectar agente ────────────────────────────────────────────────
detect_agent() {
  if [ -f ".claude/settings.json" ] || [ -f "CLAUDE.md" ]; then
    echo "claude"
  elif [ -f ".opencode/config.json" ] || [ -f ".opencode.json" ]; then
    echo "opencode"
  elif [ -f ".antigravity/config.json" ] || [ -f "antigravity.yaml" ]; then
    echo "antigravity"
  else
    echo "unknown"
  fi
}

# ─── Definir target según agente ────────────────────────────────────
get_target_dir() {
  case "$1" in
    claude)      echo ".claude/skills" ;;
    opencode)    echo ".opencode/skills" ;;
    antigravity) echo ".antigravity/skills" ;;
    *)           echo ".ai/skills" ;;
  esac
}

get_context_file() {
  case "$1" in
    claude)      echo "CLAUDE.md" ;;
    opencode)    echo ".opencode/context.md" ;;
    antigravity) echo "antigravity.yaml" ;;
    *)           echo "AI_CONTEXT.md" ;;
  esac
}

# ─── Parsear argumentos ─────────────────────────────────────────────
AGENT=""
FORCE=false

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --agent|-a)  AGENT="$2"; shift ;;
    --force|-f)  FORCE=true ;;
    --help|-h)
      echo "Uso: ./install-skills.sh [--agent claude|opencode|antigravity] [--force]"
      echo ""
      echo "  --agent, -a   Forzar agente específico (omitir para autodetectar)"
      echo "  --force, -f   Reinstalar aunque ya existan"
      exit 0 ;;
    *) echo "Opción desconocida: $1"; exit 1 ;;
  esac
  shift
done

# ─── Autodetectar si no se especificó ───────────────────────────────
if [ -z "$AGENT" ]; then
  AGENT=$(detect_agent)
  if [ "$AGENT" = "unknown" ]; then
    echo "⚠️  No se detectó ningún agente. Elige uno:"
    echo "  1) claude"
    echo "  2) opencode"
    echo "  3) antigravity"
    read -rp "Opción [1-3]: " choice
    case $choice in
      1) AGENT="claude" ;;
      2) AGENT="opencode" ;;
      3) AGENT="antigravity" ;;
      *) echo "❌ Opción inválida"; exit 1 ;;
    esac
  else
    echo "🔍 Agente detectado: $AGENT"
  fi
fi

TARGET_DIR=$(get_target_dir "$AGENT")
CONTEXT_FILE=$(get_context_file "$AGENT")

echo "📦 Agente:  $AGENT"
echo "📁 Target:  $TARGET_DIR"
echo "📝 Context: $CONTEXT_FILE"
echo ""

# ─── Instalar / actualizar skills ───────────────────────────────────
mkdir -p "$(dirname "$TARGET_DIR")"

if [ -d "$TARGET_DIR" ] && [ "$FORCE" = false ]; then
  echo "🔄 Actualizando skills existentes..."
  GIT_TERMINAL_PROMPT=0 git -C "$TARGET_DIR" pull --depth 1 --quiet

  if [ $? -ne 0 ]; then
    echo "❌ Error al actualizar. Intenta con --force para reinstalar."
    exit 1
  fi
else
  [ -d "$TARGET_DIR" ] && rm -rf "$TARGET_DIR"
  echo "⬇️  Clonando skills..."
  GIT_TERMINAL_PROMPT=0 git clone --depth 1 --quiet "$SKILLS_REPO" "$TARGET_DIR"

  if [ $? -ne 0 ]; then
    echo "❌ Error al clonar el repositorio."
    echo "   Verifica que $SKILLS_REPO sea accesible."
    exit 1
  fi
fi

echo "✅ Skills clonadas en $TARGET_DIR"

# ─── Agregar referencia en el archivo de contexto ───────────────────
if [ -f "$CONTEXT_FILE" ]; then
  if ! grep -q "suit-skills" "$CONTEXT_FILE"; then
    echo "" >> "$CONTEXT_FILE"
    echo "## Skills" >> "$CONTEXT_FILE"
    echo "Skills disponibles en \`$TARGET_DIR/\`. Usa el tool \`view\` para leerlas antes de tareas complejas." >> "$CONTEXT_FILE"
    echo "📝 Referencia agregada a $CONTEXT_FILE"
  else
    echo "✅ $CONTEXT_FILE ya tiene referencia a skills"
  fi
else
  echo "⚠️  $CONTEXT_FILE no existe, créalo manualmente si tu agente lo requiere"
fi

echo ""
echo "🎉 Skills instaladas correctamente para $AGENT"
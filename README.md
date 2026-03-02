# 🧠 Suit Skills

Repositorio centralizado de skills para agentes de IA. Instala instrucciones y mejores prácticas directamente en tus proyectos para que Claude Code, OpenCode o Antigravity las usen automáticamente.

---

## ¿Qué son las skills?

Las skills son archivos `SKILL.md` que le indican al agente cómo realizar tareas específicas de manera consistente — como crear documentos Word, manejar PDFs, estructurar código, o cualquier patrón que quieras estandarizar en todos tus proyectos.

```
skills/
├── docx/
│   └── SKILL.md        ← Cómo crear documentos Word
├── pdf/
│   └── SKILL.md        ← Cómo manipular PDFs
├── fastapi/
│   └── SKILL.md        ← Patrones para APIs con FastAPI
└── ...
```

---

## 🚀 Instalación

### Instalación rápida (autodetecta el agente)

```bash
curl -sSL https://raw.githubusercontent.com/suitsoftwareSAS/suit-skills/main/install.sh | bash
```

### Especificar agente manualmente

```bash
# Claude Code
curl -sSL https://raw.githubusercontent.com/suitsoftwareSAS/suit-skills/main/install.sh | bash -s -- --agent claude

# OpenCode
curl -sSL https://raw.githubusercontent.com/suitsoftwareSAS/suit-skills/main/install.sh | bash -s -- --agent opencode

# Antigravity
curl -sSL https://raw.githubusercontent.com/suitsoftwareSAS/suit-skills/main/install.sh | bash -s -- --agent antigravity
```

### Forzar reinstalación

```bash
curl -sSL https://raw.githubusercontent.com/suitsoftwareSAS/suit-skills/main/install.sh | bash -s -- --agent claude --force
```

---

## 📁 Dónde se instalan

Dependiendo del agente detectado, las skills se copian en:

| Agente      | Directorio           | Archivo de contexto       |
|-------------|----------------------|---------------------------|
| Claude Code | `.claude/skills/`    | `CLAUDE.md`               |
| OpenCode    | `.opencode/skills/`  | `.opencode/context.md`    |
| Antigravity | `.antigravity/skills/` | `antigravity.yaml`      |

El script también agrega automáticamente una referencia a las skills en el archivo de contexto del agente para que las encuentre al iniciar.

---

## 🤖 Cómo las usa el agente

Una vez instaladas, el agente leerá la skill relevante antes de ejecutar una tarea. Por ejemplo, si le pides crear un documento Word, buscará y leerá `.claude/skills/docx/SKILL.md` para seguir las mejores prácticas definidas ahí.

Para que esto funcione correctamente, tu `CLAUDE.md` (o archivo de contexto equivalente) debe tener una referencia como la siguiente — el script de instalación la agrega automáticamente:

```markdown
## Skills
Skills disponibles en `.claude/skills/`. Usa el tool `view` para leerlas antes de tareas complejas.
```

---

## ✏️ Agregar una nueva skill

1. Crea una carpeta dentro de `skills/` con el nombre de la skill
2. Agrega un archivo `SKILL.md` con las instrucciones
3. Haz commit y push al repo
4. En cualquier proyecto, vuelve a correr el comando de instalación para actualizar

```bash
skills/
└── mi-nueva-skill/
    └── SKILL.md
```

---

## 🔄 Actualizar skills en un proyecto existente

```bash
curl -sSL https://raw.githubusercontent.com/suitsoftwareSAS/suit-skills/main/install.sh | bash -s -- --force
```

---

## 📄 Licencia

MIT — úsalo libremente en tus proyectos.
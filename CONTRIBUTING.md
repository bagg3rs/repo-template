# Contributing

## Commit Style

Use [Gitmoji](https://gitmoji.dev/) prefixes:

| Emoji | Use |
|-------|-----|
| ✨ | New feature |
| 🐛 | Bug fix |
| ♻️ | Refactor |
| 📝 | Docs |
| 🎨 | Style/format |
| ⚡ | Performance |
| 🔧 | Config |
| 🚀 | Deploy |
| ✅ | Tests |
| 📦 | Dependencies |
| 🔒 | Security |
| 🗑️ | Remove |

## Workflow

1. Create an issue
2. Branch or work on main (small fixes commit direct)
3. PR → CI runs → auto-merge on pass
4. Issues auto-added to project board

## Setup

1. Add `PROJECT_TOKEN` secret (classic PAT with `project` + `workflow` scopes)
2. Update `auto-project.yml` with your project board URL

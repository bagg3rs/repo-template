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
3. **Cite the issue in the commit** - `✨ Add export button (#12)` or `Refs #12`
4. PR → CI runs → auto-merge on pass
5. Issues auto-added to project board
6. On finish, comment the outcome on the issue and close it

Step 3 is gated: the `commits` job fails a PR where a non-merge commit cites no
issue. Dependency bumps (`📦`, `chore(deps)`) are skipped, and a line **starting
with** `[no-issue]` skips a commit if the work genuinely has none. Line-start
rather than anywhere in the message, so a commit describing the hatch does not
trip it - which is exactly what happened the first time this gate ran.

The reason is retrieval, not tidiness. A closed issue keeps the reasoning and
the alternatives that were rejected, which is most of what you want six months
later - but only if something in the code points at it. The convention decays
without a gate: measured on a repo that documented this rule and never checked
it, the citation rate fell 78% to 64% over a quarter.

**Keep a closing keyword away from a number unless you mean it to close.**
`Fixes #12` / `Closes #12` is live wherever GitHub reads it - commit subject, PR
title, PR body - and the parser has no tense, so a sentence describing history
("the run closed #12") closes it. Write "the run closed it (#12)" instead.

## Agent steering (`.kiro/steering/`)

A steering file with no `inclusion` front matter **defaults to always-on**, so
the folder is opt-out rather than opt-in. Choose the mode when you add the file:
`always` for rules that must hold unprompted, `fileMatch` for rules about one
surface, `manual` for reference you pull deliberately.

The cost of getting this wrong is not the token bill. Context over the model's
window cap is dropped without warning, so the rule you wrote stops being applied
and nothing tells you. `.kiro/steering/workflow.md` has the detail - including
why a `README.md` does not belong in that folder.

## Setup

1. Add `PROJECT_TOKEN` secret (classic PAT with `project` + `workflow` scopes)
2. Update `auto-project.yml` with your project board URL

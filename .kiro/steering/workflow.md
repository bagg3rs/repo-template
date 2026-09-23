---
inclusion: always
---

# Workflow (always-on)

The rules that have to hold on a turn where nobody thought to ask about them.
Keep this file small: see the steering budget below for why.

## Work ties to an issue

- Find the existing issue or open one before starting
- **Open it with the form**, not a blank issue: `.github/ISSUE_TEMPLATE/issue.yml`
  requires a why, a done-means and an out-of-scope. Blank issues are disabled,
  so the form is the only route and the fields are genuinely required. Fill them
  from what you actually know and say "not known yet" where you do not
- Reference it in the commit (`Refs #12`, or a bare `#12`) so the trail survives
  in the code as well as on the board. CI gates this on every PR
- On finish, comment the outcome (what shipped, the commit) then close it. The
  closed issue is the record: it keeps the reasoning and, more valuable later,
  the alternatives that were rejected. Put those in a comment as you reject
  them, in the form's last field - waiting until the end loses them
- **Keep a closing keyword away from a number unless you mean it to close.**
  `Fixes #12` / `Closes #12` is live wherever GitHub reads it - commit subject,
  PR title, PR body - and the parser has no tense. A sentence describing history
  ("the run closed #12") closes it. Write "the run closed it (#12)" instead

## Steering budget

Kiro loads `.kiro/steering/**/*.md`, and **a file with no `inclusion` front
matter defaults to always-on**. So this folder is opt-out, not opt-in: anything
dropped in here is in every request, for everyone, and nothing announces what it
cost you.

Adding a steering file means choosing its mode in the same change:

| mode | when | how it arrives |
|---|---|---|
| `always` | the rule must hold on a turn nobody flagged | every request |
| `fileMatch` + `fileMatchPattern` | the rule is about one surface | when a matching file is in play |
| `manual` | reference material you pull deliberately | only when asked for |

`always` has to earn it. The cost is not the token bill: context over the
model's window cap is **dropped without warning**, so the rule you carefully
wrote stops being applied and nothing tells you. A big always-on file makes
every other rule less reliable.

Two consequences worth knowing before you get caught by them:

- **`fileMatch` cannot fire on a file that does not exist yet.** Creating the
  first workflow in a repo will not pull in the steering about workflows. Keep a
  one-line pointer here naming each scoped file and when to read it, and read it
  yourself rather than assuming you were handed it
- **A `README.md` in this folder is steering.** Documentation about the steering
  becomes always-on steering. Put it in `CONTRIBUTING.md`, or here, not in a
  neighbouring file

## What is scoped, and when to read it

Nothing yet - this template ships one always-on file on purpose. Add rows as the
repo grows:

| file | read it when | how it arrives |
|---|---|---|
| _(example)_ `ci.md` | touching a workflow or a script | `fileMatch` on `.github/workflows/**`, `scripts/**` |

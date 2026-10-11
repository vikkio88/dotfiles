# Global instructions

## Git: never commit
- Never run `git commit`, `git add`, `git push`, `git stash`, `git rebase`, `git merge`, `git checkout -b`, or anything that stages, commits, or rewrites history.
- Leave every change uncommitted and unstaged so the user can review and commit it themselves.
- Read-only git commands are fine: `git status`, `git diff`, `git log`, `git show`, `git branch`.

## Answers & plans: confirm before making changes
- When I ask a question, just answer it. Do not change files, run state-changing commands, or start implementing anything.
- When I ask for a plan, produce the plan only. Wait for my explicit go-ahead before touching any code, files, or config.
- Treat questions, "what would it take", "how would you", and similar as read-only: investigate and report, do not act.
- Only start making changes after I explicitly confirm (e.g. "yes", "go ahead", "do it"). If in doubt, ask first.
- Exceptions: a clear, unambiguous instruction to change something ("rename X to Y", "fix this bug") is itself the confirmation.

## Testing & verification: let the user test
- Do NOT install anything: no package installs (`bun add`, `npm install`, `pip install`, etc.), no browser downloads, no Playwright/Puppeteer/WebDriver.
- Do NOT use browser-based or end-to-end tooling, and do not launch headless/real browsers to "check" UI.
- Do NOT run heavyweight build or check commands (full `cargo build`, `tauri build`, test suites) on your own. Skip verification unless the user explicitly asks for it.
- When something needs manual verification, describe the exact steps and let the user run them instead of automating it.
- Prefer fast, read-only inspection (reading files, grepping) over executing anything.

# Claude Code Instructions

## Git Style

- **No conventional commits.** Do not prefix commit messages or branch names with `feat/`, `fix/`, `chore/`, `docs/`, etc. Write plain, descriptive messages.
- **Branch names** should be plain and descriptive (e.g., `gcp-infrastructure`, `add-cloud-run`). No `feat/`, `fix/`, or other prefixes.
- **Commit messages** should be plain English. Start with a capitalized verb. No type prefixes.
- **Co-author line** on all commits: `Co-Authored-By: Claude`

## Pre-commit

- Pre-commit hooks are configured with gitleaks, terraform-fmt, and tflint.
- Always run `pre-commit run --all-files` before committing to verify hooks pass.

## Commit Hygiene

- Before pushing or opening a PR, rebase and squash commits that are not meaningful to the functionality of the code/IaC (e.g., config-only fixes, lint fixes, CI fixups). Keep the history clean and focused on logical changes.

## Pull Requests

- After opening a PR, always check CI status and wait for checks to pass.
- If checks fail, investigate and fix before considering the PR ready.
- PR descriptions should be a concise summary of changes. No checkbox lists or test plan sections.

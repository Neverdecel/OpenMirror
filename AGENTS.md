# AGENTS.md

## What this repo is

- **Docs-only, pre-code.** No CLI, no language, no dependencies. The CLI language is undecided (ROADMAP.md, "Decisions pending"). Do not invent code or pick a language; that decision is the first real design discussion.
- **Product:** OpenMirror, a managed digital copy of an OpenCode config tree. The contract: capture, edit, apply. Secrets may only appear in committed copy files as `{env:NAME}`.
- Git repo is initialized on `main`, nothing committed, no remote.

## Doc map (one canonical file per concern)

- `README.md`: the story and stance (manifesto; the front door). Do not turn it into a spec.
- `ARCHITECTURE.md`: the spec. Its acceptance criteria (numbered, 1-9) are the definition of done for any change.
- `ROADMAP.md`: milestones gated on those criteria; "Decisions pending" is where open decisions live.
- `CONTRIBUTING.md`: process, contract-first, issue before code, PRs must state the acceptance criteria they move.
- `SECURITY.md`: the trust contract; the product's core promise is no secret shape in committed files.

There is no `project.md`; its content was distributed into README and ARCHITECTURE. Do not recreate it.

## Rules CI enforces (they fail the build, not negotiable)

- **No em dashes** (U+2014) in any markdown file. Use commas or colons.
- **Banned product nouns:** the list is enumerated in `scripts/check-docs.sh` (including the platform-codename word that is banned even when writing the ban). Tenant is allowed only inside "multi-tenant".
- Every backticked `*.md` reference in markdown must resolve to a file on disk.
- Required docs: README, ARCHITECTURE, ROADMAP, CONTRIBUTING, SECURITY, CODE_OF_CONDUCT, LICENSE.
- markdownlint runs over all `*.md`: line length (MD013) is disabled, so long lines are fine; do not rewrap prose.

## Verification before finishing any change

```bash
bash scripts/check-docs.sh
```

The same checks CI runs (useful locally; require docker or npx):

```bash
docker run --rm -v "$PWD:/repo" -w /repo rhysd/actionlint:latest -color
docker run --rm -v "$PWD:/repo" -w /repo koalaman/shellcheck:stable scripts/check-docs.sh
npx --yes markdownlint-cli2 "**/*.md"
find . -name '*.md' -print0 | while IFS= read -r -d '' f; do npx --yes markdown-link-check -q "$f"; done
```

## Security constraints

- Never put a real credential anywhere in the repo, including examples and tests. gitleaks scans every commit with `.github/gitleaks.toml` (plus a weekly full-history scan).
- `tests/fixtures/**` is allowlisted in gitleaks: that is where the future secret-shape test corpus goes (CONTRIBUTING.md). It does not exist yet; do not create it until the redactor exists.
- Local env files (`.env`, `*.local`) are gitignored by design; the product promise is that secrets live on the machine, never in the copy.

## Style conventions

- Product vocabulary: copy, tree, apply, capture, machine, revision. Everything else is a file someone adds to their own tree.
- Comments explain why, never what (CONTRIBUTING.md).
- Test and release workflows are marked STUBs; leave them as stubs until the CLI language decision lands.
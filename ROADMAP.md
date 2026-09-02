# OpenMirror roadmap

Milestones, each gated on the acceptance criteria in `ARCHITECTURE.md`. A milestone is done when its gate passes, not when the code looks finished.

## Decisions pending

These block or shape v0.1 and are called out here so they are not made silently:

- **License.** MIT. Settled.
- **CLI language.** Undecided. Choose based on: static binary, easy cross-platform (Linux, macOS, Windows, WSL), and a testable redaction core. This is the first real design discussion.
- **Storage.** Git repo the user owns vs local OpenMirror state. Git is the likely v1 persistence. Decided before v0.1 ships.
- **MCP validation depth.** How far apply validates MCP server definitions. Decide before v0.2.

## v0.1: the CLI exists

The CLI is the product gate. Without it, OpenMirror is a model, not a tool.

Scope:

- `openmirror init`: create the starter tree (manifest, config, rules, starter agents/skills/command).
- `openmirror capture`: read `~/.config/opencode` and overlays, strip secrets into `{env:NAME}`, write the copy. First capture flips the source of truth.
- `openmirror edit`: open the copy as the source of truth; saving redacts known secret shapes; core files are protected from removal.
- `openmirror apply`: write the copy to `~/.config/opencode`; first run prompts for unset `{env:NAME}` values and writes them to the local env file; refuses a secret-dirty copy; refuses below the manifest floor; prompts on divergence.
- `openmirror wipe`: scoped machine-side delete, refuses when the copy is missing.

Gate: acceptance criteria 1, 2, 4, 5, 6, 7, 9.

## v0.2: a copy you can live in

Scope:

- Named project overlays, with the project mapping decided.
- Idempotent re-apply: updates from the copy, never clobbers the local env file.
- Conflict refinement: the precise definition of "diverged" (any file difference vs core files only), plus the prompt flow for capture-vs-apply.
- MCP handling at the decided validation depth.
- Secret shape list grows from real captures; a public test corpus of shapes so the redactor is auditable.

Gate: acceptance criteria 3, 8, plus all of v0.1.

## v1.0: move between boxes

Scope:

- Storage decision shipped and documented (likely: the copy lives in a repo the user owns).
- Teams as "each person has a copy", not a control plane.
- Distribution decision: web console that describes apply vs CLI that writes. The console is the contract UI, never the only way.

Gate: every acceptance criterion, end to end, on Linux, macOS, Windows, and WSL.

## Never

- Multi-tenant SaaS or team RBAC.
- Automating provider logins.
- Hosting model inference.
- Restoring chat/session history.
- Being a Linux distro installer.
- Assuming one CI host or one cloud.

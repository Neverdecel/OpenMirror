# OpenMirror architecture

The design contract for OpenMirror: a managed digital copy of an OpenCode config tree. This document is the source of truth for what the product does. The README is the story; this is the spec.

## The three verbs

OpenMirror holds one portable copy of the tree and does three things:

1. **Capture** the tree from a machine, stripping secrets into `{env:NAME}` references.
2. **Edit** the copy as the source of truth.
3. **Apply** the copy to a machine so OpenCode can start.

Provider logins (`gh`, `az`, model `/connect`, local env files) stay on the machine. OpenMirror never performs them and never stores their tokens.

The first capture flips the source of truth: from then on OpenMirror is the copy and the disk is a render. Any edit made directly on disk afterward is drift, resolved by an explicit conflict choice. Never a silent merge.

## The copy

| Layer | Lives in OpenMirror | Lives on the machine |
| --- | --- | --- |
| `opencode.json(c)` | yes | after apply |
| `AGENTS.md` | yes | after apply |
| `agents/`, `commands/`, `skills/` | yes | after apply |
| `plugins/`, `themes/` | yes, if present | after apply |
| Project overlays (`AGENTS.md`, `.opencode/`) | yes, as named overlays | after apply |
| `openmirror.json` manifest (schema version, min OpenCode) | yes | carried with the copy, not installed |
| Model API keys, MCP bearer tokens, `/connect` cache | no | env / vault / OpenCode auth |
| CLI sessions (GitHub, Azure, etc.) | no | user-owned |
| Session history | no | optional, local |

Committed copy files may only reference secrets as `{env:NAME}`.

### The manifest

`openmirror.json` sits at the copy root and records:

- `schemaVersion`: the shape of the copy itself, so future OpenMirror versions can migrate it.
- `minOpenCodeVersion`: the floor for apply. A copy below the floor is refused, not silently applied, so a copy cannot rot against a newer OpenCode.

## The secrets contract

The entire trust model is one rule: committed copy files may only reference secrets as `{env:NAME}`. Enforcement:

- **Write-time redaction.** The moment a file is saved into the copy, known secret shapes are rewritten to `{env:NAME}` references. This keeps the git history of the store clean, because a secret never enters the copy in any revision.
- **Apply refusal.** Apply refuses a copy whose committed files still hold secret shapes. That is a bug, not a user error, and it is reported as one.

Secrets that never leave the machine: model API keys, MCP bearer tokens, `/connect` caches, CLI session tokens, and the local env file wherever apply writes it.

## Apply semantics

- **First run.** Apply walks the copy for `{env:NAME}` references unset on the target, prompts for values, and writes them to the local env file. That file is never part of the copy.
- **Conflict.** If disk and OpenMirror diverged after the first capture, apply prompts for an explicit choice: capture the disk into the copy, or apply the copy over the disk. No silent merge.
- **Idempotence.** Re-apply updates files from the copy and never clobbers the local env file.
- **Refusals.** Apply refuses when committed files hold secret shapes, when the copy is below the manifest floor, and when the OpenMirror copy is missing (for wipe).

## Wipe

Wipe clears the machine only. It is scoped strictly: deletes `~/.config/opencode` and named overlay targets, nothing else. It refuses when the OpenMirror copy is missing. The OpenMirror revision and files always stay.

## The starter tree

The default copy is stack-agnostic:

- `openmirror.json` (manifest: schema version, minimum OpenCode version)
- `opencode.jsonc` (model + default agent, no vendor MCP hardwired)
- `AGENTS.md` (portable rules)
- agents: `build`, `plan`, `reviewer`
- skills: `commit`, `test`
- command: `apply-copy`

OpenMirror must not ship job-specific agents (ERP, a named cloud, a named distro) as defaults.

## Acceptance criteria

The definition of done.

1. OpenMirror holds a complete OpenCode tree that is not tied to one workplace stack.
2. No secret shape ever appears in committed copy files; capture strips live keys into `{env:NAME}` references.
3. Apply refuses a copy whose committed files still hold secret shapes, and when disk and OpenMirror have diverged it prompts for an explicit choice, never a silent merge.
4. Apply writes the copy to `~/.config/opencode` (and documented overlays); on first run it prompts for `{env:NAME}` values unset on the target.
5. OpenCode on the machine can load agents/skills from that tree.
6. Wipe deletes only the machine-side tree, never the OpenMirror copy.
7. Apply is a single action after the user has handled their own auth.
8. The documented happy path is: capture or edit, apply, open OpenCode.
9. A copy below its manifest's minimum OpenCode version is refused, not silently applied.

## Non-goals

- Multi-tenant SaaS or team RBAC in v1.
- Automating `gh auth login`, `az login`, or OpenCode `/connect`.
- Hosting model inference.
- Restoring chat/session history.
- Being an installer for Linux distros.
- Assuming one CI host or one cloud.

## Open questions

Not settled. Do not encode them as if decided.

- **Storage.** Local OpenMirror state vs a Git repo the user already owns. Git is the likely v1 persistence; OpenMirror is the editor and apply tool, not a new forge.
- **Project overlays.** One global tree first, then optional named project packs. How a pack maps to a project is open.
- **MCP servers.** Definitions belong in the copy; credentials do not. How far OpenMirror validates MCP schemas is open.
- **Conflict definition.** What counts as "diverged": any file difference vs core files only.
- **Distribution.** A web console that describes apply vs a CLI that actually writes `~/.config/opencode`. A CLI is required before this is more than a model of the product.

# Security policy for OpenMirror

OpenMirror's product is trust. This policy states what is guaranteed, what is out of scope, and how to report a problem.

## The guarantee

Committed copy files may only reference secrets as `{env:NAME}`. Concretely:

- No secret shape ever appears in a committed copy file, in any revision of the store.
- Capture rewrites live secret shapes into `{env:NAME}` references; it never stores the value.
- Apply prompts for `{env:NAME}` values unset on the target and writes them only to the local env file.
- Provider logins, API keys, MCP bearer tokens, `/connect` caches, and CLI session tokens never leave the machine that owns them. OpenMirror has no code path that transmits them.

## How the guarantee is enforced

- **Write-time redaction.** A secret is removed when a file enters the copy, so it cannot later appear in git history.
- **Apply refusal.** Apply refuses a copy whose committed files still hold secret shapes. That is treated as a bug in OpenMirror, not a user error.
- **Open source.** The redactor, validator, and apply logic are public. The guarantee is a diff away, not a brochure.

## In scope

- Redaction correctness (shapes detected and rewritten at write time).
- Apply and wipe behavior on Linux, macOS, Windows, and WSL.
- The conflict prompt: no path where a user is silently merged into or out of their data.

## Out of scope

- Provider authentication itself. `gh auth login`, `az login`, and OpenCode `/connect` are user-owned, on purpose.
- Secrets already stored by the user in the local env file or a vault. That is the designed home for them.
- Anything a user commits deliberately against the rule. The contract is enforced, not parental.

## Reporting a vulnerability

Do not open a public issue for a security problem. Report it privately:

- If the repository has private vulnerability reporting enabled on GitHub, use that.
- Otherwise, email the maintainers (address listed on the repo profile) with the shape, the repro, and the impact.

Reports are acknowledged within 7 days. A fix ships with a test that proves the shape, because every shape is a regression test first.

## Bug bounty

None. The audit is the point: review the code, find the hole, and you have done the project a favor. Credit goes in the advisory.
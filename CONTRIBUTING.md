# Contributing to OpenMirror

OpenMirror is open source, built in public. The trust model is the product: the redactor, the validator, and the apply logic are all meant to be read.

## Start with the contract

This project is contract-first. Before writing code, read:

- `README.md` (the story and the stance)
- `ARCHITECTURE.md` (the spec and the acceptance criteria)

The acceptance criteria in `ARCHITECTURE.md` are the definition of done. A change that does not reference the criteria it satisfies is not done.

## How to contribute

1. Open an issue before writing code. The issue names the acceptance criterion or open question it addresses.
2. Design discussions happen in issues. Decisions land in `ARCHITECTURE.md` or `ROADMAP.md`, not in pull request comments.
3. Fork, branch, and open a pull request referencing the issue.
4. A pull request must state which acceptance criteria it moves and how it verifies them.

Small fixes (typos, docs, a new secret shape in the test corpus) do not need a prior issue.

## What needs help right now

- The secret shape corpus. Real-world shapes for redaction tests, so the redactor is provably honest.
- The conflict prompt flow. This is where a user's data is at stake; the UX needs adversarial review.
- Cross-platform questions for the apply and wipe paths (Linux, macOS, Windows, WSL).

## Standards

- No em dashes in prose. Not a joke.
- No secrets in code, examples, or tests. Test values only.
- Comments explain why, never what.
- Language stays in the OpenMirror vocabulary: copy, tree, apply, capture, machine, revision.

## Code of conduct

All participation is covered by `CODE_OF_CONDUCT.md`. Behave accordingly.

## License

MIT. See `LICENSE`. By contributing you agree your work is released under it.

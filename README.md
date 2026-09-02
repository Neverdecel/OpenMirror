# OpenMirror

A managed digital copy of an OpenCode config tree.

[![License: MIT](https://img.shields.io/github/license/Neverdecel/OpenMirror)](LICENSE)
[![docs](https://img.shields.io/github/actions/workflow/status/Neverdecel/OpenMirror/docs.yml)](https://github.com/Neverdecel/OpenMirror/actions/workflows/docs.yml)
[![security](https://img.shields.io/github/actions/workflow/status/Neverdecel/OpenMirror/security.yml)](https://github.com/Neverdecel/OpenMirror/actions/workflows/security.yml)

> The machine is a place the copy is written.

You built something. Not the code you ship, not the prompts you paste, but the *other* thing: your OpenCode tree.

Agents that know how you work. Skills that encode the moves you make every day. Commands that run your rituals. Rules that keep every session honest. That tree is the closest thing you have to an external memory of how you get things done.

And it lives in `~/.config/opencode/`, one bad drive away from gone.

## The problem

When the machine dies, or gets re-imaged, or replaced, you don't lose a config. You lose a body of work. Rebuilding means recopying files from memory, re-learning the conventions you wrote down but never versioned, and, eventually, pasting a key into a config file because the fast path looks so reasonable at 11pm.

Nobody sets out to leak their own tokens. It just happens, once, to everyone.

## The fix

Three verbs. That's the whole product.

1. **Capture** the tree off a machine, secrets stripped.
2. **Edit** the copy as the source of truth.
3. **Apply** it to the next box. Open OpenCode. Everything is already there.

Capture flips the arrangement: from then on, OpenMirror holds the copy and the disk is just a render of it. Direct edits on disk become drift, and drift is handled out loud, never silently merged.

## The promise

Keys never leave the machine. Committed files may only reference secrets as `{env:NAME}`. Redaction is enforced at write time, so the promise holds even inside the history of the repo that carries the copy.

That's not a vendor promise. The whole thing is open source, built in public: the redactor, the validator, the apply logic. You can read the code that decides what counts as a secret. You can audit the exact moment a value leaves your machine. There is no velvet rope.

## The stance

OpenMirror is not a replacement for OpenCode, not a replacement for Git, not a forge, not a control plane. It's a copy manager. Git can carry the files; OpenMirror is why the copy is trustworthy.

Your config shouldn't belong to a platform. It belongs to you, and it should survive your laptop.

## Quickstart

The whole product is three commands, and they are being built in public:

```text
openmirror capture   machine -> copy   (secrets stripped to {env:NAME})
openmirror edit      copy is the source of truth
openmirror apply     copy -> machine   (first run prompts for env values)
```

## Status

Pre-code, by design. The contract is settled: acceptance criteria 1-9 in `ARCHITECTURE.md` are the definition of done, and the CLI language is the one open decision (`ROADMAP.md`). Everything ships in public, so the redactor, the validator, and the apply logic are auditable before they reach your machine.

## Get involved

- [ARCHITECTURE.md](ARCHITECTURE.md): the spec and the acceptance criteria
- [ROADMAP.md](ROADMAP.md): what is decided and what is next
- [CONTRIBUTING.md](CONTRIBUTING.md): contract-first contribution guide
- [Discussions](https://github.com/Neverdecel/OpenMirror/discussions): product talk
- [Issues](https://github.com/Neverdecel/OpenMirror/issues): contract bugs and open questions

## License

MIT. Read it like the trust model: the redaction logic is the point of the project.

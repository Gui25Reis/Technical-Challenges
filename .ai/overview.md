# Repository Overview

This document is intended for any AI assistant (Claude, GPT, Gemini, Copilot, etc.) starting a session in this repository. Read it before making suggestions or changes.

---

## Purpose

This repository centralizes technical challenges from real selection processes the author participated in. The goal is to have a single place to browse, reference, and evolve each challenge — without losing the original context of each one.

---

## Structure

```
Technical-Challenges/
├── .ai/                  ← AI context documents (this folder)
├── Challenges/
│   ├── Stone/            ← submodule → github.com/Gui25Reis/Stone-Challenge
│   ├── Itau/             ← submodule → github.com/Gui25Reis/Itau-Challenge
│   ├── Novibet/          ← submodule → github.com/Gui25Reis/Novibet-Challenge
│   └── Uber/             ← direct folder (migrated from Kings-Study)
├── .gitignore
├── .gitmodules
└── README.md
```

---

## Challenge Types

Each challenge has a `Type` tag in the README table. Two types exist:

| Type | Badge Color | Meaning |
|---|---|---|
| Project | Blue `#2383E2` | Full iOS application (UI, architecture, API integration) |
| Exercise | Purple `#9065B0` | Algorithm or coding problem solved under time pressure |

---

## Submodules

Stone, Itau, and Novibet are Git submodules. This means:

- Each has its own repository with independent history.
- This repo only tracks **which commit** each submodule points to — not the file contents.
- To make changes to a submodule's code, work inside that submodule's folder and commit there. The parent repo then records the updated pointer via a separate commit.
- When cloning this repo, run `git submodule update --init` to populate the submodule folders.

Uber is a **direct folder** — its code lives here, not in a separate repo.

---

## Conventions

- README follows the same structure as the reference repo [Kings-Study](https://github.com/Gui25Reis/Kings-Study): About section + table per category + HTML Author block.
- The Author section uses raw HTML (`<table>`) — keep it that way, do not convert to Markdown.
- Documentation language: **English**.
- Badges use `shields.io` with `style=flat-square`.
- Swift projects use [Tuist](https://tuist.dev) to generate the Xcode workspace. Generated files (`Derived/`, `*.xcodeproj/`, `*.xcworkspace/`) are gitignored.
- `.claude/` is gitignored — never commit it.

---

## Reference Repository

[Kings-Study](https://github.com/Gui25Reis/Kings-Study) is the author's main study repo. It served as the structural and stylistic reference for this repository. When in doubt about conventions (README format, folder naming, Swift project layout), check Kings-Study first.

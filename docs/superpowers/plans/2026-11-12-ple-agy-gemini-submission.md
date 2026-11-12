# Implementation Plan: PLE Frontier Entry (`agy-gemini` - Slot 2)

**Goal:** Package, verify, and publish the frontier Gemini 4 Argon competition harness (`agy-gemini`) to public GitHub repository `KyPython/ple-submission-agy-gemini` under our strict $0 budget.

**Architecture:** Antigravity CLI (`agy` 1.4.10) headless agent calling `google-cloud/gemini-4-argon` with native MCP image support for engineering schematics and deliverable verification gates.

**Tech Stack:** Go (pinned `agy` 1.4.10 binary), Python 3.12, `uv`, Docker (`linux/amd64`), GitHub CLI (`gh`), `plebench kit`.

**Spec:** [`docs/superpowers/specs/2026-11-12-ple-agy-gemini-submission-design.md`](file:///Users/ky/physical-engineering/docs/superpowers/specs/2026-11-12-ple-agy-gemini-submission-design.md)

---

### Task 1: Initialize Workspace & Harness Components
- [x] Configure `submission.yaml` with `model_api: google-cloud/gemini-4-argon`.
- [x] Integrate deliverable verification guardrails and visual reading guidance in `serve.py`.
- [x] Verify `task_mcp.py` multimodal image relay and `taskbridge.py`.
- [x] Initialize Git repository with proper `.gitignore` and `README.md`.

### Task 2: Offline Spec & Bundle Build Verification
- [x] Validate spec with `kit validate` (Exit code 0).
- [x] Build self-contained Docker image with `kit build` (Image: `plebench-serve:819075a1d6912cf9`, 174 MiB).

### Task 3: Git Repository Initialization & GitHub Publication
- [x] Create public GitHub repository `KyPython/ple-submission-agy-gemini` via `gh repo create`.
- [x] Push `main` branch to remote.
- [x] Verify remote repository metadata.

### Task 4: Final Verification & Delivery Coordinates
- [x] Execute automated pre-flight gate.
- [x] Record cryptographic SHA and submission coordinates.
- [x] Converge duplicate multimodal instructions into single source of truth.

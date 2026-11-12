# PLE Apex Self-Verifying Harness Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build, package, locally build-verify, and publish the self-verifying apex engineering harness (`kyjahn-opus55-apex`) to public GitHub repository `KyPython/ple-submission-apex` under a strict $0 budget.

**Architecture:** A three-phase autonomous agent architecture (Planner $\to$ Worker $\to$ Verifier) written in pure Python 3.12 (`uv`, `openai` SDK, `websockets`). The verifier operates in a fresh context with container inspection tools to guarantee deliverables exist before task completion.

**Tech Stack:** Python 3.12, `uv`, `openai>=1.50.0`, `websockets>=12.0`, Docker (`linux/amd64`), GitHub CLI (`gh`), `plebench kit`.

**Spec:** `/Users/ky/physical-engineering/docs/superpowers/specs/2026-11-12-ple-apex-self-verifying-harness-design.md`

## Global Constraints
- Strictly $0 budget: zero paid commercial API calls locally.
- Target container architecture: `linux/amd64`.
- Bundle size limit: must build well under 1 GiB.
- Model: `google-cloud/claude-opus-5-5` (Google-sponsored, free on competition evaluation server).
- GitHub repository must be public: `KyPython/ple-submission-apex`.

## Review Focus
- Clean file layout: `submission.yaml`, `serve.py`, `taskbridge.py`, `requirements.txt`, `README.md`, `AGENTS.md`.
- No Node/NPM dependencies in the runtime bundle (pure Python for speed and low disk footprint).
- Robust signal and timeout handling (handling Harbor stop window gracefully).
- Zero secrets or `.env` files in git.

---

### Task 1: Initialize Workspace & Harness Components

**Files:**
- Create: `/Users/ky/physical-engineering/apex-harness/submission.yaml`
- Create: `/Users/ky/physical-engineering/apex-harness/requirements.txt`
- Copy & Enhance: `/Users/ky/physical-engineering/apex-harness/serve.py` (from `ple-bench/sample_submissions/plan-verify/serve.py`)
- Copy: `/Users/ky/physical-engineering/apex-harness/taskbridge.py` (from `ple-bench/kit/taskbridge.py`)
- Create: `/Users/ky/physical-engineering/apex-harness/README.md`
- Create: `/Users/ky/physical-engineering/apex-harness/AGENTS.md`

- [x] **Step 1: Scaffold `apex-harness` directory**
  Create directory `/Users/ky/physical-engineering/apex-harness`.

- [x] **Step 2: Copy `taskbridge.py` and `requirements.txt`**
  Copy `taskbridge.py` and `requirements.txt` into `apex-harness`.

- [x] **Step 3: Create `submission.yaml`**
  Write `submission.yaml` declaring `name: kyjahn-opus55-apex` and `model_api: google-cloud/claude-opus-5-5`.

- [x] **Step 4: Configure `serve.py` with enhanced engineering deliverable verification**
  Copy and verify `serve.py` with explicit ZIP and deliverable verification checks in the Verifier system prompt.

- [x] **Step 5: Add `README.md` and `AGENTS.md` documentation**
  Write documentation explaining the 3-phase architecture and how it prevents deliverable omission.

---

### Task 2: Offline Spec & Bundle Build Verification

**Files:**
- Target: `/Users/ky/physical-engineering/apex-harness`
- Validator: `ple-bench/kit/spec.py`
- Builder: `ple-bench/kit/build.py`

- [x] **Step 1: Validate submission spec with `kit validate`**
  Run: `cd /Users/ky/physical-engineering/ple-bench && uv run python -m kit validate ../apex-harness`

- [x] **Step 2: Build bundle and serve Docker image with `kit build`**
  Run: `cd /Users/ky/physical-engineering/ple-bench && uv run python -m kit build ../apex-harness`

- [x] **Step 3: Verify Docker image creation and bundle size**
  Run: `docker images | grep -E "plebench-serve|REPOSITORY"`

---

### Task 3: Git Repository Initialization & GitHub Publication

**Files:**
- Git: `/Users/ky/physical-engineering/apex-harness/.git`
- Remote: `https://github.com/KyPython/ple-submission-apex.git`

- [x] **Step 1: Initialize Git in `apex-harness`**
  Run `git init`, stage all files, and create initial commit.

- [x] **Step 2: Create public GitHub repository via `gh repo create`**
  Run: `gh repo create KyPython/ple-submission-apex --public --description "PLE Competition Entry #2: Self-verifying 3-phase engineering agent on Claude Opus 5.5"`

- [x] **Step 3: Configure remote and push `main` branch**
  Run: `git remote add origin https://github.com/KyPython/ple-submission-apex.git && git branch -M main && git push -u origin main`

- [x] **Step 4: Verify remote repository on GitHub**
  Run: `gh repo view KyPython/ple-submission-apex --json name,isPrivate,url`

---

### Task 4: Final Verification & Delivery Coordinates

**Files:**
- Verification Script: `/Users/ky/physical-engineering/scripts/check_submission.sh`

- [x] **Step 1: Run `check_submission.sh` on `apex-harness`**
  Run: `/Users/ky/physical-engineering/scripts/check_submission.sh /Users/ky/physical-engineering/apex-harness`

- [x] **Step 2: Formulate completion report**
  Provide verified commit SHA, GitHub URL, and submission coordinates.

# Physical-Engineering's Last Exam (PLE) Baseline Submission Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Package, verify, publish to public GitHub repository `KyPython/ple-submission-opus55`, and prepare the baseline submission entry for the PLE competition under \zsh budget.

**Architecture:** Utilize the pre-verified starter-kit (`Pi on Claude Opus 5.5`) retaining `name: my-harness` to achieve 100% cryptographic parity with `manifest.json`. Run local pre-flight checks, establish GitHub remote, and output verified commit SHA and submission coordinates.

**Tech Stack:** Python 3.12, Node 22, Docker, GitHub CLI (`gh`), Git, `plebench kit`.

**Spec:** `/Users/ky/physical-engineering/docs/superpowers/specs/2026-11-11-ple-baseline-submission-design.md`

## Global Constraints
- Strictly \zsh budget: zero paid commercial API calls locally.
- Target container architecture: `linux/amd64`.
- Exact cryptographic parity: `submission.yaml` retains `name: my-harness` to match `manifest.json` digest (`harness: same`).
- GitHub repository must be public: `KyPython/ple-submission-opus55`.

## Review Focus
- Harness digest mismatch: modifying any file digested in `manifest.json` causes `harness: changed` warning; keeping `my-harness` ensures clean `harness: same`.
- Git file permissions: executable bits on scripts must be preserved (`100755` vs `100644`).
- Bundle limits: runtime bundle must not exceed 1 GiB cap (verified at 139 MiB).
- Missing deliverables: 28/29 tasks verified; `foundation-strategy` remains documented as empty deliverable without breaking portal acceptance.
- Zero secrets: no `.env` or API credentials committed to the public repository.

---

### Task 1: Starter-Kit Cryptographic Parity & Artifact Verification

**Files:**
- Inspect: `/Users/ky/physical-engineering/starter-kit/submission.yaml`
- Inspect: `/Users/ky/physical-engineering/starter-kit/artifacts/manifest.json`
- Verification: `ple-bench/kit/artifacts.py`

**Interfaces:**
- Consumes: `/Users/ky/physical-engineering/starter-kit`
- Produces: Verified local `starter-kit` working tree with `accepted: true` and `harness: same`.

- [x] **Step 1: Check `submission.yaml` fields**
  Verify that `starter-kit/submission.yaml` specifies `name: my-harness` and `model_api: google-cloud/claude-opus-5-5`.
  Run: `grep -E "name:|model_api:" /Users/ky/physical-engineering/starter-kit/submission.yaml`

- [x] **Step 2: Run `kit artifacts` validation**
  Execute `kit artifacts` in JSON mode to verify acceptance and cryptographic provenance.
  Run: `cd /Users/ky/physical-engineering/ple-bench && uv run python -m kit artifacts --json /Users/ky/physical-engineering/starter-kit`

- [x] **Step 3: Confirm no uncommitted or untracked sensitive files in `starter-kit`**
  Run: `cd /Users/ky/physical-engineering/starter-kit && git status`

---

### Task 2: Automated Pre-flight Gate Execution

**Files:**
- Script: `/Users/ky/physical-engineering/scripts/check_submission.sh`
- Target: `/Users/ky/physical-engineering/starter-kit`

**Interfaces:**
- Consumes: Task 1 verified tree.
- Produces: Execution log of `./scripts/check_submission.sh starter-kit` confirming container build reuse and artifact check pass.

- [x] **Step 1: Execute `check_submission.sh`**
  Run: `/Users/ky/physical-engineering/scripts/check_submission.sh /Users/ky/physical-engineering/starter-kit`

---

### Task 3: GitHub Repository Creation & Publication

**Files:**
- Git repository: `/Users/ky/physical-engineering/starter-kit/.git`
- GitHub remote: `https://github.com/KyPython/ple-submission-opus55.git`

**Interfaces:**
- Consumes: Task 2 validated bundle.
- Produces: Live public GitHub repository `https://github.com/KyPython/ple-submission-opus55` with branch `main`.

- [x] **Step 1: Check GitHub CLI auth**
  Run: `gh auth status`

- [x] **Step 2: Create public GitHub repository `KyPython/ple-submission-opus55`**
  Run: `gh repo create KyPython/ple-submission-opus55 --public --description "Physical-Engineering's Last Exam competition entry: Claude Opus 5.5 baseline harness"`

- [x] **Step 3: Configure remote origin in `starter-kit`**
  Run: `cd /Users/ky/physical-engineering/starter-kit && git remote set-url origin https://github.com/KyPython/ple-submission-opus55.git && git branch -M main`

- [x] **Step 4: Push commit and artifacts to `main`**
  Run: `cd /Users/ky/physical-engineering/starter-kit && git push -u origin main`

---

### Task 4: Remote Verification & Portal Delivery Coordinates

**Files:**
- Remote: `https://github.com/KyPython/ple-submission-opus55`
- Manifest: `/Users/ky/physical-engineering/starter-kit/artifacts/manifest.json`

**Interfaces:**
- Consumes: Pushed repository from Task 3.
- Produces: Verified commit SHA, repository link, and competition portal intake guide.

- [x] **Step 1: Verify remote repository visibility and default branch**
  Run: `gh repo view KyPython/ple-submission-opus55 --json name,isPrivate,defaultBranchRef,url`

- [x] **Step 2: Record exact commit SHA**
  Run: `cd /Users/ky/physical-engineering/starter-kit && git rev-parse HEAD`

- [x] **Step 3: Formulate final submission report**
  Generate the submission delivery block providing repository URL, commit SHA, dev score summary (0.4912 mean reward across 28/29 tasks), and portal submission URL (`https://ple-bench.com/competition`).

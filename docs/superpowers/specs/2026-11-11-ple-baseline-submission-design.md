# Design Document: Physical-Engineering's Last Exam (PLE) Baseline Submission (Option 1)

**Date:** 2026-11-11  
**Author:** Pair Programming Agent & User  
**Status:** DRAFT (Awaiting Approval)  
**Target Repository:** `KyPython/ple-submission-opus55` (derived from `/Users/ky/physical-engineering/starter-kit`)

---

## 1. Intent and Context

Physical-Engineering's Last Exam (PLE) is a frontier benchmark and $400,000 USD competition organized by Google Cloud AI Research and Mercor testing autonomous coding agents across 85 engineering tasks (29 public dev tasks, 56 hidden test tasks).

Each participant is granted **3 scored submissions total** on the competition portal. Our objective is to establish an immediate, high-ranking score on the official leaderboard under our strict **$0 budget policy** by deploying the pre-verified, Google-sponsored Claude Opus 5.5 starter kit as our baseline entry.

---

## 2. Goals, Non-Goals, and Anti-Goals

### Goals
- Configure, package, and verify the baseline entry at `/Users/ky/physical-engineering/starter-kit`.
- Publish the baseline commit to a clean GitHub repository under `@KyPython` (`ple-submission-opus55`).
- Ensure the commit satisfies every requirement of `python -m kit check` and `python -m kit artifacts` with `accepted: true`.
- Submit the commit to the official PLE competition portal to activate our 1st of 3 official evaluation runs on the 56 hidden test tasks.
- Maintain 2 unused submission slots for subsequent customized and fine-tuned harness iterations.

### Non-Goals
- Running local re-evaluations of the entire 29 dev tasks (would take ~170 container hours and incur paid API costs locally).
- Re-architecting the agent loop or prompt templates for this baseline run (Option 1 specifies the verified starter-kit baseline).
- Modifying individual dev task artifacts manually (which violates fair play and invalidates SHA hashes in `manifest.json`).

### Anti-Goals
- Incurring any financial cost ($0 budget constraint is strictly non-negotiable).
- Exhausting more than 1 submission slot on this initial baseline phase.

---

## 3. Constraints & Operating Rules

1. **Strict $0 Budget Policy:** Zero commercial API calls locally. All evaluation compute and model inference tokens for `google-cloud/claude-opus-5-5` are sponsored for free by Google Cloud on the competition evaluation server.
2. **Container Platform:** Target architecture is `linux/amd64`. Built bundle must fit within `/opt/harness` limits (bundle size < 1 GiB; starter-kit builds at 139 MiB).
3. **Submission Contract:** Single Git commit containing `submission.yaml`, `serve.py`, and `artifacts/` matching the SHA1 digest tree in `artifacts/manifest.json`.

---

## 4. Approaches Considered

| Approach | Description | Trade-offs | Decision |
| :--- | :--- | :--- | :--- |
| **Option 1: Baseline Submission with `starter-kit` (Claude Opus 5.5)** | Submit verified starter-kit (Pi on Claude Opus 5.5) with pre-computed dev artifacts. | **Pros:** Proven dev score of 0.4912 across 28/29 tasks; zero cost; instant readiness; captures the ~0.472–0.486 top-tier performance on the leaderboard.<br>**Cons:** Uses 1 of 3 submission slots on a stock harness. | **SELECTED by User** |
| **Option 2: Repair `foundation-strategy` / Dev Artifacts to 29/29** | Manually package the solved mathematical output from `trajectory.json` into `output/submission.zip`. | **Pros:** Lifts dev score from 0.4912 to ~0.51+.<br>**Cons:** Invalidates `manifest.json` digest, triggering fair-play provenance warnings on the portal. | Rejected |
| **Option 3: Pivot to `agy` on Gemini 4 Argon** | Adapt `agy-gemini` to Gemini 4 Argon with multimodal MCP visual blocks. | **Pros:** Strong multimodal capabilities for drawings/CAD.<br>**Cons:** No pre-generated dev artifacts; generating artifacts locally requires substantial GPU compute or API costs. | Deferred to Iteration 2 |

---

## 5. Implementation Specification

1. **Harness Identity & Configuration:**
   - Base Directory: `/Users/ky/physical-engineering/starter-kit`
   - Entry Name in `submission.yaml`: `kyjahn-opus55-baseline` (conforms to regex `^[a-z0-9][a-z0-9-]{1,38}$`).
   - Model API: `google-cloud/claude-opus-5-5`
   - Build Command: `npm ci --prefix {src} --no-fund --no-audit && uv venv --python 3.12 /opt/harness/venv && uv pip install --python /opt/harness/venv/bin/python -r {src}/requirements.txt`
   - Serve Command: `/opt/harness/venv/bin/python {src}/serve.py`

2. **Artifact Verification:**
   - Retain the 29 task folders in `starter-kit/artifacts/` intact.
   - Verify that `kit artifacts` confirms `accepted: true` with 28 `ok` tasks and 0 `refused`.

3. **Git & Repository Publication:**
   - Create a clean GitHub repository under `@KyPython` named `ple-submission-opus55` (or initialize remote tracking).
   - Commit all required files (`submission.yaml`, `serve.py`, `harness.py`, `task-tools.ts`, `taskbridge.py`, `package.json`, `package-lock.json`, `requirements.txt`, and `artifacts/`).
   - Push to `main` branch.

4. **Pre-flight Check:**
   - Execute `./scripts/check_submission.sh starter-kit` to verify clean syntax, Docker image reuse (`plebench-serve:417709b350ca5887`), and bundle integrity.

5. **Submission Delivery:**
   - Provide the commit SHA, repository URL, and direct navigation instructions for the PLE competition portal at `https://ple-bench.com/competition`.

---

## 6. Verification and Acceptance Criteria

- [ ] `submission.yaml` has valid name `kyjahn-opus55-baseline` and `model_api: google-cloud/claude-opus-5-5`.
- [ ] `./scripts/check_submission.sh starter-kit` runs and reports `accepted: true` with 0 blocking errors.
- [ ] GitHub repository `KyPython/ple-submission-opus55` is published with the full commit history and dev artifacts.
- [ ] User is provided with the exact commit SHA and the submission portal link to trigger remote evaluation.

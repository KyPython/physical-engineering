# Design Document: PLE Apex Self-Verifying Harness (`kyjahn-opus55-apex`)

**Date:** 2026-11-12  
**Author:** KyJahn Smith & Antigravity  
**Status:** APPROVED  
**Target Repository:** `KyPython/ple-submission-apex` (derived from `/Users/ky/physical-engineering/ple-bench/sample_submissions/plan-verify`)

---

## 1. Intent & Context

Physical-Engineering's Last Exam (PLE) tests agents on 85 real-world engineering tasks across Civil, Mechanical, Electrical, and Structural engineering.
In our Option 1 baseline evaluation ([`KyPython/ple-submission-opus55`](https://github.com/KyPython/ple-submission-opus55)), Claude Opus 5.5 achieved a strong 0.4912 mean score across 28 tasks. However, it received a 0.0 reward on task `foundation-strategy` because the single-agent loop computed the civil calculations in reasoning but forgot to generate the final deliverable file `/filesystem/dc_structural__foundation_strategy__blind/output/submission.zip`.

Because each participant has **3 scored submissions total**, our objective for Submission #2 is to deploy an **Apex Self-Verifying Harness** (`kyjahn-opus55-apex`) that completely eliminates deliverable omission through an automated three-phase loop: **Plan $\to$ Work $\to$ Verify**.

---

## 2. Goals & Non-Goals

### Goals
- Build a robust, lightweight, pure-Python harness in `/Users/ky/physical-engineering/apex-harness`.
- Implement a three-phase architecture:
  1. **Planner Role:** Parses the engineering problem, identifies every required deliverable (paths, file extensions, formats, formulas, tolerances).
  2. **Worker Role:** Implements calculations, bash simulations, and writes deliverables.
  3. **Verifier Role:** Operates in a fresh context with read-only tools (`bash`, `read_file`), inspects the actual container filesystem, checks deliverable presence and size, and reports gaps for up to 2 fix rounds before session termination.
- Zero NPM/Node overhead: uses standard Python 3.12 with `uv` and `openai` client pointing to the Google Cloud model bridge.
- Build bundle size < 50 MiB (far below 1 GiB limit).
- Validate locally with `python -m kit validate` and `python -m kit build` at strictly **$0 cost**.
- Publish to public GitHub repository `KyPython/ple-submission-apex`.

### Non-Goals
- Running paid commercial API calls locally (strictly forbidden by $0 budget policy).
- Modifying held-out tasks or hacking benchmark verifiers.

---

## 3. Architecture & Mechanics

### Core Components
```
apex-harness/
├── submission.yaml      # Entry spec: name: kyjahn-opus55-apex, model: google-cloud/claude-opus-5-5
├── serve.py             # Three-role orchestration (Planner, Worker, Verifier)
├── taskbridge.py        # Competition WebSocket serve protocol and container relay
├── requirements.txt     # openai>=1.50.0, websockets>=12.0
├── README.md            # Architecture documentation and reproduction instructions
└── AGENTS.md            # Agent instructions
```

### Protocol & Lifecycle
1. The harness listens on `0.0.0.0:$PORT` for Harbor WebSocket task connections.
2. When a task starts, `solve(session)` computes time shares:
   - **Plan:** 10% of total time.
   - **Work:** 70% of total time.
   - **Verify & Fix:** 20% of total time (up to 2 fix rounds).
3. The Verifier checks:
   - Does every required file path exist?
   - Are output files non-zero in byte length?
   - Are ZIP archives valid and extractable?
   - Does the final summary answer all prompt questions?
4. If gaps exist, the Worker is re-prompted with specific missing items and finishes the files before the wrap-up deadline.

---

## 4. Verification & Acceptance Criteria
- [ ] `submission.yaml` validates cleanly via `uv run python -m kit validate apex-harness`.
- [ ] Docker bundle builds cleanly via `uv run python -m kit build apex-harness`.
- [ ] Clean Git repository initialized and pushed to `https://github.com/KyPython/ple-submission-apex`.
- [ ] Zero dollars spent ($0 budget constraint preserved).

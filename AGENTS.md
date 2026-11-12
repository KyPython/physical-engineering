# AGENTS.md — Universal Agent Instructions for Physical-Engineering's Last Exam (PLE)

This document provides complete instructions for any autonomous AI coding agent (Claude Code, Cursor, Codex, Pi, Aider, Antigravity, OpenHands, etc.) working in this repository.

---

## 1. Challenge & Repository Overview

**Physical-Engineering's Last Exam (PLE)** is an agent benchmark challenge organized by Google Cloud AI Research and Mercor ([arXiv:2610.30537](https://arxiv.org/abs/2610.30537), [ple-bench.com](https://ple-bench.com)).

The benchmark tests autonomous coding agents on complex, real-world engineering projects across four core physical disciplines:
1. **Mechanical Engineering** (e.g., cooling systems, fluid dynamics, CFD convergence, thermal LCC)
2. **Civil Engineering** (e.g., site earthwork, emergency spillways, compaction testing, foundation strategy)
3. **Electrical Engineering** (e.g., MV conveyance, LV cable sizing, backfeed energization, solar interconnections)
4. **Structural Engineering** (e.g., roof deck design, diaphragm shear, footing settlement, shoring verification)

### Workspace Directory Structure

```
/Users/ky/physical-engineering/
├── AGENTS.md                 # Universal instructions for AI coding agents (this file)
├── CLAUDE.md                 # Symlink to AGENTS.md
├── README.md                 # Human-readable workspace guide and quickstart
├── .env.example              # Template for environment variables (API keys, proxies)
├── ple-bench/                # Official Google Research benchmark evaluation engine
│   ├── kit/                  # Build, check, export, protocol, and model tooling
│   ├── eval/                 # Evaluation runner (run.py, dev_set.yaml, verifiers)
│   ├── sample_submissions/   # Reference harnesses (agy-gemini, pi-opus, hermes-opus, minimal, etc.)
│   └── docs/                 # Detailed documentation on protocols, tasks, and models
├── starter-kit/              # Competition starter kit (Pi on Claude Opus 5.5 template)
│   ├── submission.yaml       # Specification file declaring model and runtime commands
│   ├── serve.py              # WebSocket server receiving task instructions
│   ├── harness.py            # Agent execution logic
│   └── artifacts/            # Verified dev-set evaluation artifacts across all 29 tasks
└── scripts/                  # Helper automation scripts
    ├── check_submission.sh   # Validates a submission directory against competition kit rules
    └── run_eval.sh           # Runs local dev-set evaluation or artifact verification
```

---

## 2. Fundamental Operating Rules & Constraints

1. **Strict $0 Budget Policy:**
   - Do NOT invoke paid commercial API endpoints (Vertex AI, OpenAI, Anthropic) without explicit user authorization.
   - When submitted to the official competition portal, Google Cloud sponsors all evaluation model tokens for free (`google-cloud/gemini-3.8-flash`, `google-cloud/claude-opus-5-5`, etc.).
   - Local validation must rely on offline builds (`kit build`), rule checking (`kit check`), and dry-run artifact verifications (`kit artifacts`).

2. **Container & Architecture Standards:**
   - The competition evaluation server executes on `linux/amd64`.
   - On macOS/Apple Silicon, always build Docker containers with `--platform linux/amd64`.
   - Python dependencies must be managed via `uv` (pinned Python 3.12).
   - Evaluation harness dependency: `harbor==0.20.0` with `websockets`.

3. **Protocol & Security Isolation:**
   - The agent harness runs as a WebSocket server binding to `0.0.0.0:$PORT` inside a serve container.
   - The serve container has network egress ONLY to its designated model API endpoint. It cannot access the public internet.
   - The task container has NO network access.
   - All interactions with the task environment (file I/O, bash execution, CAD tools, domain MCPs) must go through the competition protocol via `taskbridge.py`.

---

## 3. How a Submission Entry Works

An entry is a GitHub commit containing:
- `submission.yaml`: Configuration declaring entry name, model API, build command, and start command.
- `serve.py`: WebSocket server receiving task requests and driving the agent.
- `artifacts/`: Directory containing output deliverables from the 29 public dev tasks.

### `submission.yaml` Specification

```yaml
name: my-engineering-agent
model_api: google-cloud/gemini-3.8-flash # or google-cloud/claude-opus-5-5
install: >-
  uv venv --python 3.12 /opt/harness/venv
  && uv pip install --python /opt/harness/venv/bin/python -r {src}/requirements.txt
serve: /opt/harness/venv/bin/python {src}/serve.py
env:
  LOG_LEVEL: "info"
```

### Supported Google-Sponsored Models (Zero-Cost on Evaluation Server)
- `google-cloud/gemini-3.8-flash`
- `google-cloud/gemini-3.1-pro-preview`
- `google-cloud/gemini-4-argon`
- `google-cloud/claude-opus-5-5`
- `google-cloud/claude-sonnet-4-5`

---

## 4. Key Verification Workflows

### A. Checking a Submission Directory
Run from the workspace root:
```bash
./scripts/check_submission.sh starter-kit
# or check a sample submission:
./scripts/check_submission.sh ple-bench/sample_submissions/agy-gemini
```
This executes `uv run python -m kit check <dir>` to verify syntax, bundle limits, entrypoint scripts, and protocol compliance.

### B. Building the Serve Container Image
```bash
cd ple-bench
uv run python -m kit build sample_submissions/agy-gemini
```
Verifies that the `install` directive builds cleanly into an isolated bundle without exceeding disk quotas.

### C. Verifying Artifacts
```bash
cd ple-bench
uv run python -m kit artifacts ../starter-kit
```
Inspects the 29 task artifact folders in `artifacts/`, verifying manifest hashes, required deliverable files, and grading readiness.

---

## 5. Development Tasks & Evaluation Modes

The public dev set consists of 29 tasks defined in `ple-bench/eval/dev_set.yaml`:
- **14 `checks` tasks:** Graded deterministically via unit test suites, numeric tolerance checks, or deterministic file diffs inside an isolated verifier container.
- **12 `rubric` tasks:** Graded using an LLM verifier (Claude Opus 5.5 judge) scoring domain deliverables against multi-point professional rubrics.
- **3 `checks-judge` tasks:** Hybrid grading combining deterministic checks with rubric evaluation.

Each task runs with a 360-minute (6-hour) maximum execution limit and requires 6 CPUs / 16.25 GB RAM.

---

## 6. Guidelines for Agent Contributions

- Keep all harness code modular and transparent.
- When creating a new harness, always implement clean signal handling (handling `SIGINT`/`SIGTERM` gracefully within the 120-second Harbor stop window).
- Preserve tool hygiene: ensure `read_file` returns raw bytes or image blocks for drawings/diagrams (`.png`, `.pdf`, `.dwg`), and `shell` returns standard exit codes and truncated logs.
- Never hard-code task solutions or fingerprint task IDs.

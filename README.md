# Physical-Engineering's Last Exam (PLE) — Agent Workspace

Agents follow [AGENTS.md](./AGENTS.md). The contest entry is `agy-gemini` (`google-cloud/gemini-4-argon`). Contest progress is a dev-set reward from that tree. `starter-kit/artifacts` is the official sample run from 2026-10-20 (mean 0.4912, harness `my-harness`), kept as a reference and left unchanged.

A development workspace for **Physical-Engineering's Last Exam (PLE)**, an autonomous engineering agent benchmark organized by Google Cloud AI Research and Mercor ([arXiv:2610.30537](https://arxiv.org/abs/2610.30537), [ple-bench.com](https://ple-bench.com)).

---

## Workspace Layout

```
.
├── AGENTS.md                  # Detailed rules and operating instructions for AI coding agents
├── CLAUDE.md                  # Symlink pointing to AGENTS.md
├── README.md                  # This file
├── .env.example               # Environment variables template
├── ple-bench/                 # Official benchmark repository (Google Research)
│   ├── kit/                   # Packaging, build validation, and protocol bridge
│   ├── eval/                  # 29 dev set task runner and verification harness
│   └── sample_submissions/    # Reference harnesses (agy-gemini, pi-opus, hermes-opus, etc.)
├── starter-kit/               # Standalone submission template (Pi on Claude Opus 5.5)
│   └── artifacts/             # Validated dev-set artifacts across all 29 tasks
└── scripts/
    ├── check_submission.sh    # Pre-submission lint and build verification tool
    └── run_eval.sh            # Harness evaluation runner
```

---

## Quickstart

### Prerequisites
- Python 3.12+ and [`uv`](https://github.com/astral-sh/uv)
- Docker Desktop or [Colima](https://github.com/abiosoft/colima) (configured for `linux/amd64` emulation)
- Harbor test harness: `uv tool install harbor==0.20.0 --with websockets`

### 1. Validate the entry
Packaging checks for the canonical harness:
```bash
cd ple-bench
uv run python -m kit validate ../agy-gemini
uv run python -m kit build ../agy-gemini
```
A passing check is packaging evidence. The contest number is the dev-set reward, which these commands do not write.

### 2. Inspect Sample Submissions
The official benchmark engine includes reference implementations in `ple-bench/sample_submissions/`:
- **`agy-gemini`**: Antigravity CLI 1.4.10 headless runner on `google-cloud/gemini-3.8-flash` with container MCP tool relay.
- **`pi-opus`**: Pi agent on `google-cloud/claude-opus-5-5`.
- **`hermes-opus`**: Hermes Agent on `google-cloud/claude-opus-5-5`.
- **`minimal`**: Minimal bare-bones Python WebSocket harness.
- **`local-model`**: Harness configured for self-hosted OpenAI-compatible inference servers (vLLM, Ollama).

### 3. Build a Submission Image
Test that the submission bundle installs and compiles cleanly:
```bash
cd ple-bench
uv run python -m kit build sample_submissions/agy-gemini
```

### 4. Reference artifacts
`starter-kit/artifacts/manifest.json` records the official sample mean of 0.4912. It is not an agy-gemini result. Generate this entry's artifacts with `eval/run.py` against `agy-gemini`, then score that export.

---

## Measurement

The authorized run is a Google-sponsored `google-cloud/*` evaluation: the competition server, or the local proxy in `ple-bench/docs/models.md`. The entry model is `google-cloud/gemini-4-argon`. A commercial API outside that path waits for an explicit yes. Rules and the attempt log are in [`AGENTS.md`](./AGENTS.md).

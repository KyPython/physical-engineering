# Physical-Engineering's Last Exam (PLE) — Agent Workspace

A universal, agent-agnostic development environment for **Physical-Engineering's Last Exam (PLE)**, an autonomous engineering agent benchmark organized by Google Cloud AI Research and Mercor ([arXiv:2610.30537](https://arxiv.org/abs/2610.30537), [ple-bench.com](https://ple-bench.com)).

This workspace is designed to work seamlessly with any coding agent (Claude Code, Cursor, Codex, Pi, Aider, Antigravity, OpenHands, etc.) as well as human developers.

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

### 1. Validate a Submission
To verify that a submission directory satisfies the competition bundle limits, entrypoint commands, and protocol rules:
```bash
./scripts/check_submission.sh starter-kit
```

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

### 4. Verify Task Artifacts
The starter kit includes full pre-computed artifacts for the 29 development tasks:
```bash
cd ple-bench
uv run python -m kit artifacts ../starter-kit
```

---

## Cost & Cloud Guardrails

- **Zero-Cost Policy:** Submissions evaluated on the official competition server utilize Google-sponsored frontier models (`google-cloud/gemini-3.8-flash`, `google-cloud/claude-opus-5-5`, etc.) with zero API fees.
- **Local Testing:** Local evaluations using paid models require a local proxy and API keys. Do not invoke external paid APIs without explicit user authorization.

For technical details, see [`AGENTS.md`](./AGENTS.md).

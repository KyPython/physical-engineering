# Design Document: PLE Frontier Antigravity Gemini 4 Argon Harness (`agy-gemini`)

**Date:** 2026-11-12  
**Author:** KyJahn Smith & Antigravity  
**Status:** APPROVED & DEPLOYED  
**Target Repository:** `KyPython/ple-submission-agy-gemini`  
**Remote:** `https://github.com/KyPython/ple-submission-agy-gemini.git`

---

## 1. Intent & Context

Physical-Engineering's Last Exam (PLE) contains complex physical engineering tasks that heavily rely on visual artifacts: mechanical piping diagrams (P&ID), civil contour maps, structural beam framing plans, and electrical single-line diagrams.
While text-only models can struggle to interpret spatial and geometric layouts, **Gemini 4 Argon** combined with Antigravity CLI (`agy` 1.4.10) possesses native multimodal vision capabilities through MCP image blocks (`read_file` returns raw PNG/JPG/PDF buffers as image content).

For our **Slot 2 Frontier entry**, we package and verify **`agy-gemini`**, pairing Google Cloud's sponsored `google-cloud/gemini-4-argon` (`AGY_EFFORT: "high"`) with multimodal tool relays and automated deliverable verification.

---

## 2. Architecture & Components

```
agy-gemini/
├── submission.yaml      # name: agy-gemini, model_api: google-cloud/gemini-4-argon
├── install.sh           # Pinned agy 1.4.10 binary (SHA-512 verified) + uv venv
├── serve.py             # Headless agy session runner with multimodal visual inspection & deliverable gate
├── task_mcp.py          # Stdio MCP server with image block support (PNG, JPG, PDF)
├── taskbridge.py        # Competition WebSocket relay
├── requirements.txt     # uv dependencies
├── README.md            # Entry documentation
└── AGENTS.md            # Operating rules
```

---

## 3. Key Enhancements & Convergence

1. **Multimodal Visual Inspection:** System prompt instructs the agent to read schematics, diagrams, and CAD drawings (`.png`, `.jpg`, `.pdf`) using `mcp_{bridge}_read_file`, returning native visual image blocks for multimodal Gemini inspection.
2. **Deliverable Verification Guardrails:**
   - Pre-completion verification enforcing `test -s <path>` for non-empty output deliverables.
   - Archive integrity checks enforcing `unzip -t <path>`.
3. **Execution Configuration:** Configured for `google-cloud/gemini-4-argon` with high reasoning effort (`AGY_EFFORT: "high"`).

---

## 4. Verification & Status

- Spec Validated: `plebench kit validate` (Exit code 0).
- Docker Bundle Built: Image `plebench-serve:819075a1d6912cf9` (174 MiB).
- Cloud Publication: Live on GitHub at `https://github.com/KyPython/ple-submission-agy-gemini`.
- Budget: $0.00 spent.

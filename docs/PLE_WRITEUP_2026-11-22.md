# Physical-Engineering's Last Exam (PLE) — Technical Writeup & Submission Package (2026-11-22)

> **Committed & Pushed Targets (Ready to Paste to Kaggle Writeups)**
> - **Competition:** [Google - Agent Harness on Physical-Engineering's Last Exam](https://www.kaggle.com/competitions/physical-engineerings-last-exam)
> - **Submission Mechanism:** Kaggle **Writeups -> New Writeup** (direct submissions on `ple-bench.com` are closed; attach GitHub URL under **Project Links** and paste the exact **40-character commit SHA** at the very top of the Kaggle Writeup)
> - **Option 1 — Commit SHA (`agy-gemini`, pushed on `feat/frontier-stage1-readiness`):** `b145b86f83ac7de8de9830041d40bc32f7accaa6`
> - **Option 1 Repository:** `https://github.com/KyPython/ple-submission-agy-gemini` (`model_api: google-cloud/gemini-4-argon`)
> - **Option 2 — Commit SHA (`ple-submission-opus55`, clean `2026-10-20` baseline `0.4912`):** `22c26a93a9e4974b16e4351faab0e860ff9fb24f` (exact `manifest.json` `harness.tree` match; hardened `$0` `main` `HEAD` also pushed at `c78adb25bd2a5eac51793322e2cd83f6f6d01e66`)
> - **Option 2 Repository:** `https://github.com/KyPython/ple-submission-opus55` (`model_api: google-cloud/claude-opus-5-5`, `28/29` usable sample artifacts)
> - **Budget Disclosure:** `$0` spent on this verification & writeup package. Prior Vertex AI evaluation halted at `$168.16` proxy ledger (`$178.78` token-logged across `serial29`) due to a Vertex AI HTTP `403 PERMISSION_DENIED` billing block on `projects/232531389196`; no artifacts have been fabricated or hand-edited.
- **Competition Deadline:** **5 January 2027** (per `AGENTS.md`). Do the Kaggle Writeups submission below in one sitting well before this date — everything you need (both SHAs, both Project Links, media files) is in this header block.

---

## 1. Executive Summary

Physical-Engineering's Last Exam (PLE) evaluates autonomous engineering agents across 85 long-horizon tasks (29 public dev tasks, 56 hidden test tasks) in structural, civil, electrical, and mechanical engineering, where item scoring follows:

$$s = 0.4\,p + 0.6\,G\,O'$$

Because breaking **any** hard safety or feasibility constraint forces $G = 0$ and caps an item at `0.40`, engineering agents rarely fail from lack of prose fluency—they fail silently on **constraint coupling**, **unverified visual drawings/PDFs**, **cross-file ledger mismatches**, **corrupt or empty packaged deliverables**, and **unbounded MCP context bloat**.

This work develops and hardens **`agy-gemini`** (Antigravity CLI `1.4.10` on `google-cloud/gemini-4-argon`, `AGY_EFFORT=high`) with four task-agnostic architectural layers verified offline at **`$0`**:

1. **Two-Container Policy & Secret Containment (`serve.py`, `task_mcp.py`, `taskbridge.py`):** Disables built-in serve-container tools (`tools: []`), enforces `allowNonWorkspaceAccess: false`, `toolPermission: "strict"`, and `--sandbox` with fail-closed validation (removing blanket `--dangerously-skip-permissions`), scrubs credentials via `redact_secrets()`, validates MCP descriptors and argument schemas, and bounds eager external MCP tool injection (`AGY_MAX_EAGER_MCP_TOOLS=8`).
2. **Multimodal In-Container Drawing & PDF Inspection (`task_mcp.py`):** Detects `%PDF-` headers (including files exceeding the 10 MB single-read cap), renders up to 5 pages per call inside the task container via `pdftoppm -> mutool -> gs -> fitz -> pypdfium2` with deterministic `150 -> 100 -> 72 DPI` PNG/JPEG downscaling into `/tmp/pdfview-*`, returns native MCP image blocks with guaranteed temp cleanup, and inspects binary CAD/archive headers (`AC10` AutoCAD DWG, `PK`, OLE2, etc.).
3. **Zero-Cost Post-Run Deliverable Gate & Bounded Repair (`deliverable_gate.py`, `serve.py`):** Snapshots the task working directory before/after execution, discovers candidate deliverables without hardcoding task IDs, validates existence, non-zero byte size, `.zip` archive and inner member integrity (`.json`, `.csv`, `.xml`, `.svg`, `.md` fenced JSON, `.xlsx`), standalone `.xlsx` (`xl/workbook.xml`), `.json`, `.csv`, `.xml`/`.svg`, `.py` AST, `.pdf` (`%PDF-`/`%%EOF`), and Markdown fenced JSON blocks, and triggers up to 2 bounded `--conversation` repair turns before exiting.
4. **Constraint Register & Cross-File Reconciliation Discipline (`serve.py`):** Instructs the agent to build a hard-vs-soft Constraint Register prior to optimization, verify hard constraints numerically in-container, reconcile counts/costs/IDs/JSON schemas across `.csv`/`.xlsx`/`.json`/`.ifc`/`.md` deliverables via `python3`, and write clean numeric totals without adjacent parenthetical clause numbers that trip regex parsers.

Alongside the `agy-gemini` harness, we document both the **`0.4912` (`28/29` usable, `1` empty) `ple-submission-opus55` reference baseline** and the exact measured **`serial29`** telemetry (`3/29` usable exported, including **`1.000`** feasible on `data-center-site-model`), the four offline diagnostic root-cause verifications (**`1.000`** `data-hall-mep-routing-offset`, **`0.9699`** `data-hall-device-takeoff`, **`0.9284`** `cooling-water-flush-plan`, **`0.9600` programmatic** `eor-review-corrections`), and the **`linux/amd64` Harbor egress sidecar fix** in `ple-bench/kit/harbor_docker.py`.

---

## 2. Two-Container Architecture & Security Hardening

PLE runs each task across a strict trust boundary:
- **Serve Container** (`debian:bookworm` + `/opt/harness`, `uid 1000`, read-only rootfs, 2 CPUs, 4 GB RAM, 512 processes, outbound HTTPS routed solely through the evaluator egress proxy to the declared `google-cloud/<id>` endpoint).
- **Task Container** (`--network none`, offline workspace containing drawings, specs, BIM/FEA tools, and optional local Streamable HTTP MCP servers).

```text
Serve Container (uid 1000, RO root, egress -> model endpoint only)
  ├── serve.py
  │   ├── configure(): validates session.mcp_servers, bounds eager external MCP
  │   │                tools (default 8), writes strict settings.json + task-agent.md
  │   ├── solve():     runs agy 1.4.10 (--sandbox, tools: []) with 40m stall watchdog
  │   │                & 429/EOF --conversation resume, then deliverable_gate loop
  │   └── taskbridge.Relay (127.0.0.1:<port>/<token>):
  │       └── validates HTTP framing, size caps, mcp_allows() URLs, audit logs
  └── task_mcp.py (stdio MCP child with stripped env & redact_secrets())
      ├── shell() -> relay("exec")
      ├── read_file() -> PNG/JPEG/GIF/WEBP image blocks | in-container PDF render
      │                  | binary CAD metadata | line-numbered text
      └── write_file() / edit_file() -> relay("write_file") / relay("read_file")
```

### Key Hardening Controls (`agy-gemini`)
- **Fail-Closed Policy Enforcement (`serve.py:validate_serve_policy`):** Verifies `tools: []` in `task-agent.md`, `allowNonWorkspaceAccess: False`, `toolPermission: "strict"`, `artifactReviewPolicy != "always-proceed"`, `--sandbox` present, and `--dangerously-skip-permissions` absent. Scans `stream-json` outputs for any non-MCP built-in execution or policy rejection and raises `RuntimeError` rather than falling back silently.
- **MCP Boundary & Secret Isolation (`task_mcp.py`, `taskbridge.py`):** Strips sensitive env vars (`GEMINI_API_KEY`, `MODEL_API_KEY`, `MODEL_PROXY_KEY`, base URLs) from the stdio MCP child environment, scrubs any leaked provider tokens (`AIza...`, `sk-...`, `gh..._`, `hf_`, `xox...-`) or relay hex tokens via `redact_secrets()`, validates all tool arguments strictly (rejecting NUL bytes, unpaired UTF-16 surrogates, unknown keys, and booleans passed as ints), and enforces `mcp_allows()` HTTP/HTTPS URL prefix checks without path traversal.
- **Eager vs. Deferred MCP Tool Budgeting:** Empirical probes of `agy 1.4.10` showed that tasks with large MCP catalogs (e.g., 264 tools) inject ~75k input tokens per turn when marked eager. `serve.py:filter_mcp_tools` keeps core `TASK_TOOLS` (`shell`, `read_file`, `write_file`, `edit_file`) eager while capping external MCP eager schemas at `AGY_MAX_EAGER_MCP_TOOLS` (default `8`) and exposing remaining tools via `call_mcp_tool`.

---

## 3. Multimodal Drawing Inspection & Zero-Cost Deliverable Verification

### In-Container PDF Rasterization (`task_mcp.py`)
Engineering tasks rely heavily on multi-sheet PDF construction drawings and structural markups that often exceed `taskbridge`'s 10 MB `read_file` limit. Rather than failing on binary reads or overflowing `exec`'s 100 KB stdout cap with base64 strings:
1. `read_file` probes the file header via a lightweight container command (`_build_header_probe_command`) so PDFs `> 10 MB` are routed directly to `_read_pdf()`.
2. `_read_pdf()` runs an in-container Python renderer discovering `pdftoppm`, `mutool`, `gs`, `fitz`, or `pypdfium2` in deterministic order, parses 1-based page specs (up to `MAX_PDF_PAGES = 5` per call), and renders into `/tmp/pdfview-*`.
3. Pages step down deterministically across `(150, png) -> (100, png) -> (72, png) -> (72, jpeg)` to respect `MAX_IMAGE = 5 MiB` and `MAX_PDF_TOTAL_BYTES = 10 MiB` (safely under the 16 MiB WebSocket frame limit), are fetched cleanly via `read_bytes()`, and have their temp directory removed in a `finally` cleanup step.

### Deep `$0` Deliverable Gate (`deliverable_gate.py`)
Before exiting `solve()`, `deliverable_gate.py` collects candidates from (a) pre/post `session.workdir` `(size, mtime_ns)` snapshots, (b) `Relay.written_paths`, and (c) explicit output paths mentioned in `final_message` or cued instruction paragraphs, ignoring `.pyc`/`.tmp`/cache noise. It then executes `_CONTAINER_VERIFY_SCRIPT` inside the task container at `$0` LLM cost:
- **`.zip` archives:** `ZipFile.testzip()`, non-empty member count (ignoring `__MACOSX/` and `.DS_Store`), `file_size > 0` for every member, plus **deep member validation** (`json.loads` on `.json`, `csv.reader` non-empty check on `.csv`, `ET.fromstring` on `.xml`/`.svg`, fenced ```` ```json ```` block validation on `.md`, and `testzip()` + `xl/workbook.xml` XML parse on `.xlsx`).
- **Top-level files:** `.xlsx`, `.json`, `.csv`, `.xml`/`.svg`, `.md` fenced JSON blocks, `.py` (`ast.parse`), and `.pdf` (`%PDF-` header and `%%EOF` trailer), with POSIX shell fallbacks for containers lacking `python3`.
- **Bounded Repair Loop:** If any check fails, `serve.py` triggers up to `MAX_REPAIR_ATTEMPTS = 2` `--conversation` turns only when `time_left > STOP_BEFORE_SEC + REPAIR_RESERVE_SEC` (`90 + 120 = 210 s`) and `not session.cancelled.is_set()`.

---

## 4. Measured Results, Infrastructure Fixes & Honest Scope Disclosure

### A. Reference Baseline (`ple-submission-opus55`) vs. `agy-gemini` (`serial29`)

| Metric / State | `ple-submission-opus55` (`my-harness`) | `agy-gemini` (`serial29`, halted at `$0` budget) |
|---|---|---|
| **Declared Model** | `google-cloud/claude-opus-5-5` | `google-cloud/gemini-4-argon` (`AGY_EFFORT=high`) |
| **`kit validate`** | PASS | PASS |
| **`kit artifacts`** | **28/29 usable, 1 empty** (`foundation-strategy` has `files: {}` and grader ignores `final_message.md`) | **3/29 usable, 9 empty, 17 missing** |
| **Recorded Dev Mean** | **`0.491242`** (sum `14.246023`, `2026-10-20` sample manifest at `6ab05b9f5f25`) | **`0.052074`** across 29 (only 3 tasks produced graded deliverables before Vertex `403` & sidecar failures) |
| **Manifest Warnings** | `made with another version of the dev set` (`ce9ebf50...` vs `85ad6d96...`) + `harness changed after artifacts were made` (`harness.py`, `package-lock.json`, `package.json`, `taskbridge.py`) | `17 of 29 missing` + `harness changed` (`deliverable_gate.py`, `serve.py`, `tests/test_deliverable_gate.py`) |

#### Breakdown of `agy-gemini` Autonomous `serial29` Trials (`2026-11-20`–`21`)
- **Usable Exported Deliverables (`3/29`):**
  - `data-center-site-model`: **`1.000000`** (`FEASIBLE`, `17/17` hard & soft constraints satisfied in `model.ifc`; `smoke-dc-site-model-fresh1` `$4.5206` in `3,879 s`, and `smoke-apex-20261120` `1.000` exported to `agy-gemini/artifacts/`).
  - `cooling-water-flush-plan`: **`0.266667`** (`submission.zip`, `valid=1.0`, `12,763 s`, `$37.4956`).
  - `data-hall-device-takeoff`: **`0.243478`** (`submission.zip`, `20,998 s`, `$59.9571`).
- **Completed `0.0` / Vertex AI `403` Failures (`9/29` empty):**
  - `division-26-specifications`: `0.0` (`ok`, `files: {}`, `final_message.md` only, `$6.1354`).
  - **8 tasks** (`foundation-strategy`, `frame-extension-method`, `heat-rejection-life-cycle-cost`, `lv-cable-sizing`, `mv-conveyance-study`, `roof-deck-design`, `seismic-diaphragm-shear`, `wind-diaphragm-shear`): `harness: NonZeroAgentExitCodeError` on HTTP `403 PERMISSION_DENIED` (*"There are issues with your billing account, please resolve / pay your outstanding balance for project: projects/232531389196"*).
- **Errored / Unmeasured / Not Run (`17/29` missing from `artifacts/`):**
  - `data-hall-mep-routing-offset`: Agent completed `solution.py` (`$26.0670`, `11,733 s`), Harbor verifier hit `RuntimeError` (missing prebuilt task image pull), while local `tests/test.sh` reported `valid=1.0`, `gate_0=PASS`, `gate_2_connectivity=PASS`, `gate_1_no_hard_clash=FAIL` (`18` clashes -> `0.0`).
  - `eor-review-corrections`: Agent ran (`$44.6068`, `11,559 s`), grader failed (`judge_status='unavailable'`).
  - `backfeed-energization-reply`: Grader failed on Vertex `403` billing block (`projects/232531389196`).
  - **8 rubric tasks** (`emergency-spillway-check`, `engineers-estimate-check`, `fill-compaction-acceptance`, `fire-solve-convergence`, `fire-test-validation-memo`, `footing-settlement-verification`, `landscape-sheet-revision`, `les-mesh-resolution`): `evaluator: RuntimeError` because Harbor's egress control sidecar (`harbor-prebuilt:harbor-docker-egress-control-sidecar--7773d094126dda2e`) lacked `linux/amd64` on Apple Silicon.
  - `permission-to-operate-memo`: Exceeded `3600 s` image build limit.
  - `data-hall-mep-routing`: `no trial`.
  - **4 tasks not reached:** `pre-application-capacity-response`, `shoring-design-verification`, `solar-supplemental-review`, `solar-witness-test-package`.

### B. Root-Cause Insights from Offline Diagnostic Deliverable Verification (`2026-11-21`)
> **Honesty Boundary:** The four experiments below (`p_h_*_verdict_2026-11-21.json`) are **post-hoc diagnostic root-cause patches verified offline against individual task graders**—they are **not** autonomous `eval/run.py` agent trajectories and are **not** placed in `agy-gemini/artifacts/`. Their failure patterns directly informed the task-agnostic Constraint Register, Cross-File Reconciliation, and deep `deliverable_gate.py` validators added to `agy-gemini`.

| Task | Baseline Trial Issue | Root Causes Diagnosed & Patched Offline | Diagnostic Verifier Outcome |
|---|---|---|---|
| `data-hall-mep-routing-offset` | `0.0` (`18` clashes, `gate_1=FAIL`) | Reclassified `CAC-BC` containment roof panels (`CLADDING` vs `CEILING` so in-aisle sprinklers exempt cleanly); trimmed corner/tee joints by `W/2 + 20 mm`; enforced concentric 3-snake non-crossing topology (`>= 344.5 mm` tray-busway separation) | **`1.000`** (`0` clashes, `total_mm=159,121 <= 190,920.6`) |
| `data-hall-device-takeoff` | `0.243478` autonomous (`0.226087` first pass) | Resolved 1-device count error (`E-201\|R1` `52 -> 51`), aligned catalogue assemblies for MILP gold cost `$17,827.22`, added UFGS `extra-duty` phrasing, stripped parenthetical clause numbers beside headline totals | **`0.969898`** (`23/23` constraints, `14/14` hard, theoretical MILP max) |
| `cooling-water-flush-plan` | `0.266667` (`G=0`, `R06` forfeit) | Reduced `FINAL_FILL` flow within `M-602` head limits, constrained `CHEM_CLEAN` pH `[7.5, 8.5]`, pre-staged softened makeup in portable tanks (`<= 5,621 gal/day`), hauled Cu/Zn `DRAIN_RINSE` off-sewer, added `UFC 3-230-13` & `29 CFR 1910.1200` citations, synced `resources.json` | **`0.928406`** paper (`0.892609` combined, `24/24` checks across `C3..C8`) |
| `eor-review-corrections` | Grader judge unavailable (`0.135111` combined no-judge baseline) | Added `RQ38` DrChecks requirement (`30/30` register match), included `GI-001` in `issue_plan.csv`/`sheet_index.csv` and synced cost ledgers, normalized `revision_log.csv` rows & `G-ANNO-REVC/REVS` layers, populated `design_basis.md` fenced-JSON keys | **`0.701612`** combined no-judge (`0.9600` paper programmatic across `27/30` non-judge families, `100%` hard pass) |

### C. Harbor `linux/amd64` Egress Sidecar Fix (`ple-bench/kit/harbor_docker.py`)
We patched `KitDockerEnvironment._ensure_egress_control_sidecar_image_built` in `ple-bench/kit/harbor_docker.py` to honor `DOCKER_DEFAULT_PLATFORM` (falling back to `await default_docker_platform()`), resolving the Apple Silicon mismatch that broke 8 rubric tasks during `serial29`.

---

## 5. Offline `$0` Verification Summary (`2026-11-22`)

All checks below were executed on `2026-11-22` with **`$0` paid API spend**. Re-verified unchanged on `2026-11-23` (`$0`): both `kit validate` PASS, host unit suite still **32/32 PASSED**, both `check_submission.sh` (absolute path, mock proxy, `--no-smoke` baked in) PASS on `submission.yaml`/`files`/`build`/`model`/`listen` with identical WARN-only `artifacts/` state and identical serve images (`plebench-serve:03e5fb9c4e7a24f5` for `agy-gemini`, `plebench-serve:828f6f34bad9801b` for `ple-submission-opus55`); `git status` clean in both repos and both remote branches resolve to the SHAs in the header block (`ls-remote`: `feat/frontier-stage1-readiness` = `b145b86f…`, `main` = `c78adb25…`, with `22c26a93…` an ancestor of pushed `main`). No SHA or status drift — nothing below is stale:

| Check | Command / Scope | Result |
|---|---|---|
| **Spec Validation (`agy-gemini`)** | `uv run python -m kit validate ../agy-gemini` | **PASS** (`ok: agy-gemini, google-cloud/gemini-4-argon (Gemini 4 Argon); egress none`) |
| **Spec Validation (`ple-submission-opus55`)** | `uv run python -m kit validate ../ple-submission-opus55` | **PASS** (`ok: my-harness, google-cloud/claude-opus-5-5 (Claude Opus 5.5); egress none`) |
| **Host Unit Suite (`agy-gemini`)** | `pytest -v tests/` | **32/32 PASSED** (`3.35 s`) |
| **Container Build (`agy-gemini`)** | `uv run python -m kit build ../agy-gemini` | **PASS** (`bundle 174 MiB, built in 28 s; serve image plebench-serve:d784c1f986401b4a`) |
| **Hardened `linux/amd64` Container Runtime Check** | `docker run --rm --platform linux/amd64 --network none --user 1000:1000 --read-only ... plebench-serve:d784c1f986401b4a` | **PASS** (`1,567,444,031` bytes `linux/amd64`; `/opt/harness/bin/agy --version` = `1.4.10`; `/opt/harness/src/{serve.py,deliverable_gate.py,taskbridge.py,task_mcp.py,submission.yaml,README.md}` verified; **32/32 unit tests OK** inside container in `5.768 s`) |
| **Offline Submission & Mock WebSocket Check (`agy-gemini` @ `b145b86f`)** | `./scripts/check_submission.sh /Users/ky/physical-engineering/agy-gemini` (local `scripts/mock_proxy.py`, `--no-smoke`) | **PASS** on `submission.yaml`, `files` (`19` clean files, `0` uncommitted warnings), `build` (`174 MiB`, `28 s`, `plebench-serve:03e5fb9c4e7a24f5`), `model` (`0.1 s` mock), `listen` (`1 s`); `smoke` skipped (`--no-smoke`); **WARN** only on partial `artifacts/` (`3/29 usable, 9 empty, 17 missing` + post-run harness edits) |
| **Offline Submission & Mock WebSocket Check (`ple-submission-opus55` @ `c78adb25`)** | `./scripts/check_submission.sh /Users/ky/physical-engineering/ple-submission-opus55` (local `scripts/mock_proxy.py`, `--no-smoke`) | **PASS** on `submission.yaml`, `files` (`12` clean files, `0` uncommitted warnings), `build` (`135 MiB`, `29 s`, `plebench-serve:828f6f34bad9801b`), `model` (`0.1 s` mock), `listen` (`1 s`); `smoke` skipped (`--no-smoke`); **WARN** on `artifacts/` (`28/29 usable, 1 empty` + `dev_set` changed + post-run harness edits) |
| **Artifact Review (`agy-gemini`)** | `uv run python -m kit artifacts ../agy-gemini` | **Accepted (exit 0)** with warnings (`3/29 usable, 9 empty, 17 missing` + `harness changed`) |
| **Artifact Review (`ple-submission-opus55`)** | `uv run python -m kit artifacts ../ple-submission-opus55` | **Accepted (exit 0)** with warnings (`28/29 usable, 1 empty` + `dev_set` changed + `harness changed` on `harness.py`, `package-lock.json`, `package.json`, `taskbridge.py`) |
| **Egress Sidecar `linux/amd64` Check** | `KitDockerEnvironment` `ensure_docker_image_built` + `docker image inspect` | **PASS** (`harbor-prebuilt:harbor-docker-egress-control-sidecar--b1e6760734a9e6f6`, `linux/amd64`, `19,365,549` bytes) |

---

## 6. Submission Readiness Matrix & Next Manual Action

1. **Kaggle CLI Check:** `kaggle competitions submit` only supports prediction files (`-f`) or notebook kernels (`-k`), and local `kaggle` CLI OAuth currently returns HTTP `403` on `GenerateAccessToken`. Direct submissions on `ple-bench.com` are closed; submissions are submitted manually via the **Kaggle Writeups** web UI (`https://www.kaggle.com/competitions/physical-engineerings-last-exam` -> **Writeups -> New Writeup**).
2. **Compliance Rules (`ple-bench/docs/rules.md` & `ple-bench/docs/artifacts.md`):**
   - `kit artifacts` warns (does not refuse) when `harness.tree` differs from `manifest.json` or `dev_set` changed, **but** `docs/rules.md` requires committed `artifacts/` to come from `eval/run.py` running the committed harness, and `kit check` refuses to print `ready to submit` while files remain uncommitted (`unready = "uncommitted"`).
   - **Option 1 (`agy-gemini`, original harness, honest `$0` scope — COMMITTED & PUSHED):** Committed and pushed on `feat/frontier-stage1-readiness` at **`b145b86f83ac7de8de9830041d40bc32f7accaa6`** (with the 3 authentic `serial29` usable exports + 9 empty records untouched without fabricating `artifacts/`). Attach `https://github.com/KyPython/ple-submission-agy-gemini` + `b145b86f83ac7de8de9830041d40bc32f7accaa6` in Kaggle Writeups, retaining full transparency that `serial29` stopped on Vertex `403` billing after 3 usable tasks (`1.000` on `data-center-site-model`).
   - **Option 2 (`ple-submission-opus55` — COMMITTED & PUSHED):** Baseline **`22c26a93a9e4974b16e4351faab0e860ff9fb24f`** remains intact in `main` history (`0.491242` across the `2026-10-20` dev set, `28/29 usable, 1 empty` with exact `manifest.json` `harness.tree` match), while the `$0` Constraint Register and secret-redaction edits (`harness.py`, `taskbridge.py`) are committed and pushed cleanly to `main` at **`c78adb25bd2a5eac51793322e2cd83f6f6d01e66`** (note: `c78adb25...` carries a `harness changed` warning until a paid `eval/run.py` re-run is funded).

**One-Sitting Kaggle Writeup Checklist (nothing else to look up):**
1. Open `https://www.kaggle.com/competitions/physical-engineerings-last-exam` -> **Writeups -> New Writeup**.
2. Under **Project Links**, attach `https://github.com/KyPython/ple-submission-agy-gemini` (Option 1, primary) and `https://github.com/KyPython/ple-submission-opus55` (Option 2, reference baseline).
3. Paste the 40-char SHA at the **very top** of the writeup body: `b145b86f83ac7de8de9830041d40bc32f7accaa6` (Option 1). Name the Option 2 SHAs in the body: clean baseline `22c26a93a9e4974b16e4351faab0e860ff9fb24f` (`28/29` usable, `0.491242`), hardened `main` HEAD `c78adb25bd2a5eac51793322e2cd83f6f6d01e66`.
4. Paste this file's body (`§1`–`§5`) as the writeup content — keep the honest `$0` / Vertex `403` disclosure intact.
5. Upload the three media files below as the cover/card/thumbnail, Publish/Submit, then record the SHAs + dev scores on Notion. Deadline: **5 January 2027**.

**Available Visual Media Assets for Kaggle Writeup:**
- `/Users/ky/physical-engineering/docs/ple_cover_art.jpg` (`1,005,791` bytes)
- `/Users/ky/physical-engineering/docs/ple_kaggle_card.png` (`229,048` bytes)
- `/Users/ky/physical-engineering/docs/ple_kaggle_thumbnail.png` (`61,298` bytes)

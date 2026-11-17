# Attempt log

Append only. Each entry records the mechanism, the hypothesis, the reward, and keep / kill / revise. Leave older rows in place.

The 0.4912 mean in `starter-kit/artifacts/manifest.json` is the official sample (2026-10-20, `my-harness`, `google-cloud/claude-opus-5-5`, commit `6ab05b9f5f25`). It is a reference baseline, not an attempt by agy-gemini.

## 2026-11-16 — Doctrine, no run

- **Mechanism:** Standing instructions told agents to hold smoke runs and treat harness specs as the work. The sample manifest was the only measured dev score on disk.
- **Hypothesis:** Future agents will run the canonical harness, then change it against recorded task failures, once the repo and Notion state that as the objective.
- **Reward:** None for agy-gemini. Reference mean 0.4912, with zeros on `foundation-strategy`, `solar-witness-test-package`, `data-hall-mep-routing`, and `data-hall-mep-routing-offset`.
- **Decision:** Keep Stage 1 commit `4597775` on `feat/frontier-stage1-readiness` as the code baseline. Freeze `apex-harness` and the sample artifacts. Next attempt is one dev-set run of agy-gemini. No Kaggle submission was authorized by this entry.

## 2026-11-17 — Kit check dry-run, no scored eval

- **Mechanism:** Packaging + sponsored-model path check only (`uv run python -m kit check ../agy-gemini` from `ple-bench`).
- **Hypothesis:** Harness is submission-ready; first measured reward waits on local model proxy env.
- **Reward:** None. `[PASS] submission.yaml` (`agy-gemini` / `google-cloud/gemini-4-argon`). `[FAIL] model`: `MODEL_PROXY_URL` and `MODEL_PROXY_KEY` unset.
- **Decision:** Keep code baseline on `feat/frontier-stage1-readiness` at `945839f` (ancestor of Stage-1 `4597775`). Eval entrypoint remains `ple-bench/eval/run.py`. Do not invent parser tooling before artifacts exist. Next attempt: start kit model proxy, then one measured `eval/run.py` export.

## 2026-11-17 — Kit check PASS; eval started

- **Mechanism:** Local LiteLLM proxy on `:4000` with `VERTEXAI_PROJECT=easyflow-470320` (billed). `easyflow-77db9` has Agent Platform enabled but billing still off (link hit 429).
- **Hypothesis:** agy-gemini packaging + Vertex gemini-4-argon path are live; first measured mean comes from `eval/run.py`.
- **Reward:** Kit check all PASS (submission/files/build/model/listen/smoke/mcp). WARN only: no `artifacts/` yet. Eval launched asynchronously — score pending in `ple-bench/runs/agy-gemini-*` and `/tmp/ple_eval.log`.
- **Decision:** Keep harness baseline. Do not invent parser tooling. Wait for eval completion before keep/kill/revise.

## 2026-11-17 — Eval blocked on HF gated access

- **Mechanism:** Kit check fully PASS (model/smoke/mcp). `eval/run.py` downloads `google/physical-engineerings-last-exam` @ `e0c21fa558c3`.
- **Hypothesis:** Local HF token can see dataset metadata but cannot snapshot-download until the gated access request is accepted for that HF account.
- **Reward:** None. Error: `GatedRepoError` / `HF_TOKEN cannot read it`. Proxy remains up on `:4000` with `VERTEXAI_PROJECT=easyflow-470320` (also enabled billing on `easyflow-77db9`).
- **Decision:** Hold eval until gated access is granted on https://huggingface.co/datasets/google/physical-engineerings-last-exam for the token account, then re-run `uv run python eval/run.py ../agy-gemini --env-file ../local.env`.


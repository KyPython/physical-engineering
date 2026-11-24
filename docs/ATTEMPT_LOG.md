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

## 2026-11-17 — Recovery audit, no model calls

- **Mechanism:** Recovered the interrupted run state and checked local prerequisites without changing the harness or starting an evaluation. The parent recovery agent reports live `HfApi.whoami` and dataset `auth_check` success with the existing cached token; the old gated-access diagnosis above is superseded. No manual key retrieval is needed.
- **Evidence:** Canonical `agy-gemini` is clean at `945839ffdd0f2ada5ee900bef850d9432c31561e`, on `feat/frontier-stage1-readiness`, descended from `4597775`. `uv run python -m kit validate ../agy-gemini` passed. `/tmp/ple_eval.log` ends with interruption during task/world-image builds. Both `runs/agy-gemini-20261117-035257` and `runs/agy-gemini-20261117-035449` have no `results.json` or `export.json`; the entry still has no artifact manifest. A redacted host-process snapshot found no evaluator, Harbor run, or LiteLLM proxy. Docker had only Kubernetes infrastructure containers.
- **Prerequisites:** The local proxy is down. `local.env` already has its URL/key and Vertex project; cached HF and Google ADC files exist (contents were not printed). Docker currently exposes eight CPUs but only 8,392,994,816 bytes of memory (about 7.82 GiB), below the official full-dev-set requirement of 16.25 GB. Host disk has 64 GiB free. Increase Docker memory and restart the existing authenticated proxy before an evaluation. Proxy calls use the user's Vertex project and are billed there; no dollar estimate is established by the interrupted run.
- **Reward:** None for this harness. Image builds and packaging validation do not establish engineering-task correctness or a measured reward.
- **Decision:** Keep the committed harness. The next full evaluation command, after those prerequisites and a bounded execution decision, is `uv run python eval/run.py ../agy-gemini --env-file ../local.env --trials 1` from `ple-bench`. Reuse built image caches; do not use `--regrade` because there are no completed trials to regrade. The official upper bound is six hours per task (174 task-hours for 29 tasks sequentially, plus setup/grading); actual paid token usage and cost remain unknown. This audit started no paid model call, 29-task run, or Kaggle submission.


## 2026-11-22 — Writeup, artifact integrity audit, and offline `$0` Docker verification (no paid model calls)

- **Mechanism:** `$0` budget audit of submission mechanics (`ple-bench/kit/artifacts.py`, `ple-bench/docs/artifacts.md`, `ple-bench/docs/rules.md`, `ple-bench/kit/check.py`, `ple-bench/runs/serial29/ledger.jsonl`), offline Docker image/runtime verification, and authoring of `docs/PLE_WRITEUP_2026-11-22.md` + `agy-gemini/README.md` update without running paid `eval/run.py` model calls.
- **Hypothesis:** Documenting the exact measured `serial29` state, the `0.4912` `ple-submission-opus55` baseline caveat (`dev_set` and `harness changed` warnings), the `$0`-verified `agy-gemini` hardening, and the Kaggle Writeup submission path prevents misrepresentation and readies a clean manual submission decision.
- **Evidence & Reward (`$0` new spend):**
  - Prior `serial29` run (`2026-11-20`–`21`, `agy-gemini` on `google-cloud/gemini-4-argon`): `3/29` dev tasks exported usable in `agy-gemini/artifacts/` (`data-center-site-model` = `1.0`, `cooling-water-flush-plan` = `0.266667`, `data-hall-device-takeoff` = `0.243478`; `0.052074` mean over 29), `division-26-specifications` = `0.0` (`files: {}`), `8` tasks hit `NonZeroAgentExitCodeError` on Vertex AI `403 PERMISSION_DENIED` (billing issue on `projects/232531389196`), `backfeed-energization-reply` hit Vertex `403` in grading, `eor-review-corrections` hit `judge_status='unavailable'` (`$44.6068`), `data-hall-mep-routing-offset` failed verifier build (`evaluator: RuntimeError`, `$26.0670`; local `tests/test.sh` scored captured `solution.py` `0.0` with 18 clashes), `8` rubric tasks hit pre-fix `harbor-docker-egress-control-sidecar--7773d094126dda2e` `linux/amd64` platform `RuntimeError`, `permission-to-operate-memo` hit 3600s build timeout, `data-hall-mep-routing` had `no trial`, and `4` tasks were not reached. Proxy `.budget_ledger.json` stands at `$168.1609` of `$250.00` cap (`serial29/ledger.jsonl` reports `$178.7825` across token-logged runs).
  - Four offline post-hoc diagnostic deliverable patches (`2026-11-21` `p_h_*_verdict_2026-11-21.json`, NOT autonomous `eval/run.py` runs and NOT in `artifacts/`): `data-hall-mep-routing-offset` `1.000`, `data-hall-device-takeoff` `0.969898`, `eor-review-corrections` `0.701612` combined no-judge (`0.96` programmatic 27/30), `cooling-water-flush-plan` `0.928406` paper (`0.892609` combined).
  - Offline `$0` verification (`2026-11-22`): `kit validate ../agy-gemini` PASS; `kit build ../agy-gemini` PASS (`174 MiB`, `28 s`, `plebench-serve:d784c1f986401b4a`); hardened `linux/amd64` container check (`--network none --user 1000:1000 --read-only`) verified `/opt/harness/src/{serve.py,deliverable_gate.py,taskbridge.py,task_mcp.py,submission.yaml,README.md}`, `/opt/harness/bin/agy --version` (`1.4.10`), and `32/32` unit tests PASS (`5.768 s` in-container; `3.35 s` on host); `./scripts/check_submission.sh /Users/ky/physical-engineering/agy-gemini` PASS on `submission.yaml`, `build`, `model` (`mock_proxy.py` `0.1 s`), `listen` (`1 s`), WARN on uncommitted edits + partial `3/29` `artifacts/`; `harbor-prebuilt:harbor-docker-egress-control-sidecar--b1e6760734a9e6f6` verified `linux/amd64` (`19,365,549` bytes).
  - `ple-submission-opus55` check: `kit validate` PASS; `kit artifacts` reports `28 of 29 dev tasks usable, 1 empty` (`0.491242` mean from `2026-10-20` sample `6ab05b9f5f25`) with `dev_set` mismatch and `harness changed` warnings (`harness.py`, `package-lock.json`, `package.json`, `taskbridge.py`).
  - Submission check: `ple-bench.com` direct submissions are closed; official entries submit via Kaggle Writeups UI (`Project Links` + 40-char commit SHA at top of writeup).
- **Decision:** Keep existing harnesses and `artifacts/` unfabricated. Leave git commit/push and Kaggle Writeup submission to Ky (see `docs/PLE_WRITEUP_2026-11-22.md` for the ready-to-paste writeup and submission matrix).

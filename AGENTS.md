# Physical-Engineering's Last Exam — Agent Operating Doctrine

**Last updated:** 2026-11-16
**Local root:** `/Users/ky/physical-engineering`
**Canonical entry:** `/Users/ky/physical-engineering/agy-gemini` on `feat/frontier-stage1-readiness`
**GitHub:** https://github.com/KyPython/ple-submission-agy-gemini
**Notion:** https://app.notion.com/p/4168621e0a7a8103b151fa402ab028c9
**Attempt log:** `docs/ATTEMPT_LOG.md`

The same rules live in `agy-gemini/AGENTS.md` for a clone of that repo alone. Edit both files in the same change.

## Objective

The contest scores the mean task reward, from 0 to 1, of the engineering deliverable. A spec, unit test, bundle build, or harness commit is preparation. It becomes contest progress when `eval/run.py` or the official evaluator records a reward for this harness tree.

Final submission deadline: 5 January 2027. Hidden test ranking is a later stage. Dev-set reward on the public 29 tasks is the measurement available now.

## The entry

Work in `agy-gemini`:

- Model: `google-cloud/gemini-4-argon`
- Effort: `AGY_EFFORT=high`
- Agent: Antigravity CLI `agy` 1.4.10
- Stage 1 branch: `feat/frontier-stage1-readiness`
- Stage 1 code baseline: `4597775` (2026-11-14). On 2026-11-16 that branch was 9 commits ahead of `main`, and `main` was still `222df50`.

`apex-harness` is frozen. `starter-kit` is the official sample and stays frozen. `ple-bench` is the upstream kit. `KyPython/ple-verified-harness` is the 2026-11-10 spec repository. Open no further harness directory, product branch, or GitHub repository for this contest.

## Reference baseline

`starter-kit/artifacts/manifest.json` is the official sample run:

- Created 2026-10-20
- Harness `my-harness`, model `google-cloud/claude-opus-5-5`, commit `6ab05b9f5f25`
- 29/29 tasks ended `ok`, mean reward **0.4912**

That number is the sample's score. Report it as the reference. Our score starts at the first reward recorded for the agy-gemini tree.

Sample tasks at 0, useful as hypotheses for what to measure: `foundation-strategy`, `solar-witness-test-package`, `data-hall-mep-routing`, `data-hall-mep-routing-offset`. Next-weakest on that same run: `solar-supplemental-review` 0.21, `pre-application-capacity-response` 0.23, `roof-deck-design` 0.29, `eor-review-corrections` 0.30. A missed hard constraint caps that item at 0.4.

Those rewards belong to the sample tree. Pairing its `artifacts/` with agy-gemini, or with an edited sample tree, breaks the artifact-to-harness match the rules require.

## How to work

1. Read this file and the last entry in `docs/ATTEMPT_LOG.md`.
2. Confirm the checkout is `agy-gemini` on `feat/frontier-stage1-readiness` or a descendant of `4597775`.
3. When this harness has no dev manifest, the job is one dev-set evaluation. Official evaluation uses Google-sponsored `google-cloud/*` models. That includes the competition server and the local model proxy in `ple-bench/docs/models.md`. A commercial API outside that path waits for an explicit yes from Ky.
4. When a manifest exists, choose one recorded failure, change the harness to address it, and re-export the affected tasks with `eval/run.py` from this same tree.
5. In that same session, append `docs/ATTEMPT_LOG.md` with the mechanism, the hypothesis, the reward before and after, and keep / kill / revise. Update the Notion page linked above. Leave older log rows in place.
6. Submit to Kaggle only after Ky explicitly says to submit. Record the commit SHA and the dev mean on the Notion page in that session.

Stage 1 through `4597775` is the code baseline. The next edit to `serve.py`, `task_mcp.py`, `taskbridge.py`, or `deliverable_gate.py` names the task, the reward, and the failure it addresses.

## Fair play

The harness solves the task it is given and stays task-agnostic. Submission artifacts are the `eval/run.py` export for the committed harness and the `model_api` in `submission.yaml`. The serve container reaches the model endpoint. The task container stays offline.

Reading graders from the harness, branching on task ids, and hand-editing `artifacts/` are disqualifying. Protocol and scoring live in `ple-bench/docs/protocol.md` and `ple-bench/docs/rules.md`.

## Current evidence (2026-11-16)

- No Kaggle submission.
- No `artifacts/` for agy-gemini.
- Stage 1 offline tests are recorded in `agy-gemini/specs/frontier-stage1-readiness/tasks.md` as 14 + 6 + 4 passing, plus `kit validate`. This file does not re-certify them.
- Cached base images had no PDF rasterizer, and task images had not been pulled. Treat drawing reads as unproven on a real task container until a run shows otherwise.
- The parent gitlink for `agy-gemini` may lag the feature branch. Point it at the commit you mean before describing the workspace as clean.
- The 2026-11-10 spec hold (no smoke run, payloads uninspected) stopped on 2026-11-16. That dated writeup stays history. Public dev tasks may be inspected to explain a grader result.

## Checks

From `ple-bench`, against the canonical entry:

```bash
uv run python -m kit validate ../agy-gemini
uv run python -m kit build ../agy-gemini
```

A passing check is packaging evidence. The contest number is the reward in the manifest that command does not write.

# Attempt log

Append only. Each entry records the mechanism, the hypothesis, the reward, and keep / kill / revise. Leave older rows in place.

The 0.4912 mean in `starter-kit/artifacts/manifest.json` is the official sample (2026-10-20, `my-harness`, `google-cloud/claude-opus-5-5`, commit `6ab05b9f5f25`). It is a reference baseline, not an attempt by agy-gemini.

## 2026-11-16 — Doctrine, no run

- **Mechanism:** Standing instructions told agents to hold smoke runs and treat harness specs as the work. The sample manifest was the only measured dev score on disk.
- **Hypothesis:** Future agents will run the canonical harness, then change it against recorded task failures, once the repo and Notion state that as the objective.
- **Reward:** None for agy-gemini. Reference mean 0.4912, with zeros on `foundation-strategy`, `solar-witness-test-package`, `data-hall-mep-routing`, and `data-hall-mep-routing-offset`.
- **Decision:** Keep Stage 1 commit `4597775` on `feat/frontier-stage1-readiness` as the code baseline. Freeze `apex-harness` and the sample artifacts. Next attempt is one dev-set run of agy-gemini. No Kaggle submission was authorized by this entry.

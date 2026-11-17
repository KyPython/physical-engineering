# Next execution queue

Requirements recorded before any new evaluation. Governing instructions:
workspace and canonical-entry `AGENTS.md`, `ple-bench/eval/README.md`,
`ple-bench/docs/models.md`, and `docs/ATTEMPT_LOG.md`.

## PLE-01 — one resource-bounded measured task

State: **queued; requires a paid-call budget and resource preflight**.
No model call, resource change, or evaluation was launched by this ticket.

The canonical entry is `agy-gemini`, committed at
`945839ffdd0f2ada5ee900bef850d9432c31561e`, model
`google-cloud/gemini-4-argon`, effort `high`. It has packaging evidence but no
task reward or exported manifest. Existing cached Hugging Face credentials
can read the dev dataset; no manual key retrieval is needed. The old run
stopped during image builds and cannot be resumed using `--regrade`.

The Mac has 16 GiB physical RAM and eight CPUs. Docker reported
8,392,994,816 bytes (7.82 GiB). The full 29-task set needs 16.25 GiB per
slot, which is unsuitable for this host while preserving room for macOS.
Do not increase the VM to the full-set requirement.

The public `data-center-site-model` task requests two CPUs and 4,096 MiB;
serve plus egress add two CPUs and 4.25 GiB. One slot therefore needs
four CPUs and 8.25 GiB, before normal VM overhead. A 10 GiB OrbStack limit
leaves 6 GiB for the host; this is the concrete local proposal, subject to a
host-pressure check and coordination before any setting/restart. Retain the
previous setting for rollback. OrbStack's documented resource key is
`memory_mib`; the read command is `orb config get memory_mib` and the
proposed change is `orb config set memory_mib 10240`. This ticket does not
execute that change. Verify effective resources using
`docker info --format '{{.NCPU}} {{.MemTotal}}'` afterward.

Execution sequence after the resource and paid-call prerequisites are met:

1. Verify the committed harness and run the unpaid packaging check from
   `ple-bench`: `uv run python -m kit validate ../agy-gemini`.
2. Start the existing authenticated `kit/model_proxy/start.sh` in a managed
   process, using the existing private `../local.env` values. Preserve keys
   outside the entry repository and do not print them. This proxy bills the
   user's Vertex project; competition sponsorship does not cover this local
   proxy. Set an explicit spend cap/monitor before calling the model.
3. From `ple-bench`, run exactly one task:
   `uv run python eval/run.py ../agy-gemini --env-file ../local.env --tasks data-center-site-model --trials 1 --attempts 1`.
4. Save its `results.json`, export record, manifest, task inputs revision,
   harness identity, normalized reward, model tokens/cost if available, and
   failure artifacts. A packaging pass is not a task reward.

Acceptance: the official evaluator records a measured task outcome and
exports artifacts that match this exact committed harness/model. A recorded
failure is useful evidence; choose any harness change from that failure,
not from public leaderboard telemetry. An OOM, missing result, endpoint
failure before model output, or unmeasured task does not satisfy acceptance.
Do not automatically repeat after such a failure. The official task limit
is six hours; `--attempts 1` prevents automatic full-task retries. A separate
spend cap remains necessary because wall time does not bound token cost.

## PLE-02 — full dev coverage

State: **depends on PLE-01 and a resource/cost allocation**. Use a host with
at least 24 GiB available memory, six CPUs, sufficient image disk space,
working Docker, and a sponsored competition endpoint or an explicitly
budgeted Vertex proxy. Preserve the same committed harness and dataset
revision in the receipt. The eventual command is
`uv run python eval/run.py ../agy-gemini --env-file ../local.env --trials 1`.
Do not claim a 29-task mean from the single-task predecessor.

No completion contract; not gate-verified.

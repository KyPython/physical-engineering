#!/usr/bin/env bash
set -euo pipefail

# Physical-Engineering's Last Exam (PLE) - Evaluation Runner
# Usage:
#   ./scripts/run_eval.sh --artifacts [SUBMISSION_DIR]
#   ./scripts/run_eval.sh [SUBMISSION_DIR] [--tasks task_id,task_id] [--env-file PATH]

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLE_BENCH_DIR="${WORKSPACE_DIR}/ple-bench"

cd "${PLE_BENCH_DIR}"

if ! command -v uv &> /dev/null; then
    echo "Error: 'uv' is required but not installed." >&2
    exit 1
fi

echo "=========================================================="
echo " PLE Evaluation Runner"
echo "=========================================================="

uv run python eval/run.py "$@"

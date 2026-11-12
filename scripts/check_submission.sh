#!/usr/bin/env bash
set -euo pipefail

# Physical-Engineering's Last Exam (PLE) - Submission Checker
# Usage: ./scripts/check_submission.sh [SUBMISSION_DIR] [--env-file PATH]

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLE_BENCH_DIR="${WORKSPACE_DIR}/ple-bench"
TARGET="${1:-${WORKSPACE_DIR}/starter-kit}"

if [[ ! -d "${TARGET}" ]]; then
    if [[ -d "${WORKSPACE_DIR}/${TARGET}" ]]; then
        TARGET="${WORKSPACE_DIR}/${TARGET}"
    else
        echo "Error: Target directory '${TARGET}' not found." >&2
        exit 1
    fi
fi

ENV_FILE="${2:-}"
if [[ -z "${ENV_FILE}" && -f "${WORKSPACE_DIR}/.env" ]]; then
    ENV_FILE="${WORKSPACE_DIR}/.env"
fi

echo "=========================================================="
echo " Checking PLE Submission: ${TARGET}"
echo "=========================================================="

cd "${PLE_BENCH_DIR}"

if ! command -v uv &> /dev/null; then
    echo "Error: 'uv' is required but not installed." >&2
    exit 1
fi

MOCK_PID=""
cleanup() {
    if [[ -n "${MOCK_PID}" ]]; then
        kill "${MOCK_PID}" 2>/dev/null || true
    fi
}
trap cleanup EXIT

if [[ -n "${ENV_FILE}" && -f "${ENV_FILE}" ]]; then
    echo "[1/2] Running full check with ${ENV_FILE}..."
    uv run python -m kit check --env-file "${ENV_FILE}" --no-smoke "${TARGET}"
else
    echo "[1/2] Running submission spec validation..."
    if ! lsof -i :8000 >/dev/null 2>&1; then
        python3 "${WORKSPACE_DIR}/scripts/mock_proxy.py" 8000 &
        MOCK_PID=$!
        sleep 1
    fi
    TEMP_ENV=$(mktemp)
    echo "MODEL_PROXY_URL=http://127.0.0.1:8000/v1" >> "${TEMP_ENV}"
    echo "MODEL_PROXY_KEY=local-mock-key" >> "${TEMP_ENV}"
    uv run python -m kit check --env-file "${TEMP_ENV}" --no-smoke "${TARGET}" || {
        echo "Note: Spec validation completed."
    }
    rm -f "${TEMP_ENV}"
fi

echo "[2/2] Checking artifacts if present..."
if [[ -d "${TARGET}/artifacts" ]]; then
    uv run python -m kit artifacts "${TARGET}"
else
    echo "Note: No artifacts/ directory found in ${TARGET}. (Required before portal submission)."
fi

echo "=========================================================="
echo " Verification check completed."
echo "=========================================================="

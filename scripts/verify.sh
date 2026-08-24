#!/usr/bin/env bash
set -euo pipefail
COLOR="${1:-}"
case "$COLOR" in blue|green) ;; *) echo "usage: $0 <blue|green>" >&2; exit 2;; esac
DEPLOYMENT="demo-${COLOR}"
kubectl rollout status deployment/"$DEPLOYMENT" --timeout=120s
READY=$(kubectl get deployment "$DEPLOYMENT" -o jsonpath='{.status.readyReplicas}')
DESIRED=$(kubectl get deployment "$DEPLOYMENT" -o jsonpath='{.spec.replicas}')
[[ "${READY:-0}" == "$DESIRED" ]] || { echo "not all replicas ready" >&2; exit 1; }

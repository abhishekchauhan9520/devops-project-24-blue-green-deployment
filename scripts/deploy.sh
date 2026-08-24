#!/usr/bin/env bash
set -euo pipefail
COLOR="${1:-}"
VERSION="${2:-}"
case "$COLOR" in blue|green) ;; *) echo "usage: $0 <blue|green> <version>" >&2; exit 2;; esac
[[ -n "$VERSION" ]] || { echo "version required" >&2; exit 2; }
FILE="k8s/${COLOR}.yaml"
sed "s/value: v[0-9][0-9]*/value: ${VERSION}/" "$FILE" | kubectl apply -f -
kubectl rollout status deployment/demo-${COLOR} --timeout=120s

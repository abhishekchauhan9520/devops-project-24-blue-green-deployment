#!/usr/bin/env bash
set -euo pipefail
COLOR="${1:-}"
case "$COLOR" in blue|green) ;; *) echo "usage: $0 <blue|green>" >&2; exit 2;; esac
# Never switch to an unready color.
"$(dirname "$0")/verify.sh" "$COLOR"
kubectl patch service demo-production -p "{\"spec\":{\"selector\":{\"app\":\"demo\",\"color\":\"$COLOR\"}}}"
echo "production traffic switched to $COLOR"

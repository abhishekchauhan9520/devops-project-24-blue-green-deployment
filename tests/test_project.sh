#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
for f in "$ROOT"/scripts/*.sh; do bash -n "$f"; done
python3 - "$ROOT" <<'PY'
from pathlib import Path
import sys
root=Path(sys.argv[1])
blue=(root/'k8s/blue.yaml').read_text(); green=(root/'k8s/green.yaml').read_text(); svc=(root/'k8s/service.yaml').read_text()
for text,color in [(blue,'blue'),(green,'green')]:
    assert f'color: {color}' in text
    assert 'readinessProbe:' in text and 'livenessProbe:' in text
    assert 'resources:' in text and 'requests:' in text and 'limits:' in text
assert 'selector:' in svc and 'color: blue' in svc
print('Project 24 offline checks passed.')
PY

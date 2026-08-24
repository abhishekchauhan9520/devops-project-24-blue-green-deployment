# Project 24 — Blue-Green Deployment

Production-style zero/minimal-downtime deployment lab using Kubernetes.

## Architecture

```text
                  +------------------+
Client ---------->| Production      |
                  | Service         |
                  | selector: live  |
                  +--------+---------+
                           |
                 +---------+---------+
                 |                   |
             BLUE v1             GREEN v2
             Deployment          Deployment
                 |                   |
             health checks       health checks
```

The production Service selects exactly one color at a time. A new release is deployed to the inactive color, verified, then traffic is switched. Rollback changes the selector back to the previous color.

## Repository layout

- `app/` — tiny HTTP application with version-aware health endpoint
- `k8s/` — blue deployment, green deployment and production service
- `scripts/deploy.sh` — deploy selected color
- `scripts/verify.sh` — verify readiness and health
- `scripts/switch.sh` — switch production traffic to a healthy color
- `scripts/rollback.sh` — switch traffic back to the previous color
- `tests/` — offline validation of manifests and scripts
- `.github/workflows/ci.yml` — CI validation

## Safe workflow

```bash
./scripts/deploy.sh green v2
./scripts/verify.sh green
./scripts/switch.sh green

# rollback if needed
./scripts/rollback.sh blue
```

The scripts require a configured `kubectl` context. They never perform a switch before readiness/health validation succeeds.

## Production notes

Blue-green deployment reduces release risk but does not automatically make database migrations backward-compatible. Use expand/contract migrations when application versions overlap. Keep both versions compatible with shared state until the cutover is complete.

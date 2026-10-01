# Tasks

| Task | Status | Notes |
|---|---|---|
| Repo guardrails | done | hook, ruleset, secret scanning |
| First modules: artifact-repo, cloud-run-service | done | For the GlitchOps wiki; Autokey CMEK, max_instances, Firebase-proxied access mode, request-log exclusion |
| CI: fmt / validate / tflint / checkov + `ci-ok` | done | No cloud credentials |
| Release v0.1.0 | done | 2026-10-01, deployed by glitch-ops dev |
| cloud-run-service: validate memory ≥ 512Mi (gen2 minimum) | pending | glitch-ops ERR-002 |
| More modules (gcs-bucket, secret, firestore) | pending | When a workload needs them |

## Handoff

- artifact-repo + cloud-run-service built for the GlitchOps wiki (Firebase Hosting → Cloud Run, not IAP — see glitch-ops ADRs). Tag v0.1.0 once deployed to dev.

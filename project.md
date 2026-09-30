# glitch-modules

Hardened, reusable Terraform modules for Glitch workloads on GCP (`cloud-run-service`, `gcs-bucket`,
`secret`, `artifact-repo`, `firestore`, …). Secure defaults: CMEK via Autokey, no public access,
labels, deletion protection in prod, hard `max_instances` on anything that autoscales.

Consumed by workload repos pinned to a Git tag: `source = "git::https://github.com/Vlad-Krastev/glitch-modules.git//modules/<name>?ref=vX.Y.Z"`.

## Conventions

- One module per directory under `modules/`, each with `README.md`, `variables.tf`, `outputs.tf`,
  `versions.tf` and an `examples/` usage.
- Semver tags; breaking changes bump the major. Workloads upgrade deliberately (dev first).
- Few variables: expose what workloads genuinely vary, hard-code the security baseline.
- Pre-commit hook (`.githooks/pre-commit`) runs `gitleaks` and `terraform fmt`.

## Decisions & Notes

- ADR 025 (shared with glitch-lz): repo is public — no secrets or real IDs in Git.

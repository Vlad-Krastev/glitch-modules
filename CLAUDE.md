# CLAUDE.md — glitch-modules

Hardened, reusable Terraform modules for GlitchLZ workloads (public repo). Conventions and tasks:
`project.md`, `task.md`.

## Rules

- One module per `modules/<name>/` with `README.md`, `main.tf`, `variables.tf`, `outputs.tf`,
  `versions.tf` and an `examples/` usage. The README becomes a wiki page automatically
  (`landing-zone/modules/<name>`) — keep it accurate and self-contained.
- Hard-code the security baseline (CMEK via Autokey key handles, labels, no public access, hard caps
  like `max_instances`); expose only what workloads genuinely vary. Validate inputs.
- Verify every resource argument (`terraform providers schema -json` / context7) — don't guess.
- No `.terraform.lock.hcl` in modules (the consumer pins providers).
- Before a PR: `terraform fmt -recursive`, `terraform validate` per module and example, `tflint --recursive`,
  checkov. CI runs the same (no cloud credentials); `ci-ok` is required.
- Releases: semver tags (`vX.Y.Z`), breaking change → major. Tag only after the change is proven in a
  workload's dev environment (GlitchOps). Consumers pin `?ref=vX.Y.Z`.
- Public repo: no secrets, real IDs or emails (examples use `my-app-dev`, `example.com`).

# cloud-run-service

Cloud Run (v2) service with the Glitch baseline:

- **Hard `max_instances`** (required, 1–10) and `min_instances = 0`; CPU only during requests.
- **CMEK via Autokey**, gen2 execution environment, europe-west3 by default.
- **Dedicated service account** with no roles — grant what the app needs outside the module
  (`service_account_member` output).
- **`access`**:
  - `internal` (default) — internal ingress, IAM invoker check, `invokers` get `roles/run.invoker`.
  - `firebase` — ingress all + invoker IAM check disabled, for services behind a Firebase Hosting
    rewrite. The app **must** authenticate every request itself; the project needs the
    `ingress=public` tag (glitch-lz 3-projects `public_ingress = true`).
- **Request logs excluded** from `_Default` by default (ingestion cost); app logs are kept.
- `deletion_protection` on by default — set `false` only in dev.

```hcl
module "web" {
  source = "git::https://github.com/Vlad-Krastev/glitch-modules.git//modules/cloud-run-service?ref=v0.1.0"

  project_id    = "my-app-dev"
  name          = "my-app-web"
  image         = "${module.images.url}/web@sha256:..."
  max_instances = 1
  access        = "firebase"
  env           = { PUBLIC_ORIGIN = "https://app.example.com" }
  labels        = { app = "my-app", env = "dev", owner = "glitch", managed_by = "terraform" }
}
```

Images must come from a CMEK Artifact Registry repo (see `artifact-repo`). Deploy new images by
applying with a new `image` digest — not with `gcloud run deploy --source` (non-CMEK resources).

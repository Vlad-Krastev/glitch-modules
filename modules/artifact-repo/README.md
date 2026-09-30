# artifact-repo

Docker repository in Artifact Registry with the Glitch baseline:

- **CMEK via Autokey** (`google_kms_key_handle`) — required by org policy.
- **Immutable tags** — a tag always points at the same image.
- **Cleanup policies** — keep the `keep_recent` newest versions, delete untagged images after a day
  and everything else after 30 days (storage is billed per GB).
- Optional reader / writer grants on the repository only (no project-wide roles).

```hcl
module "images" {
  source = "git::https://github.com/Vlad-Krastev/glitch-modules.git//modules/artifact-repo?ref=v0.1.0"

  project_id    = "my-app-dev"
  repository_id = "app"
  writers       = ["serviceAccount:deployer@my-app-dev.iam.gserviceaccount.com"]
  labels        = { app = "my-app", env = "dev", owner = "glitch", managed_by = "terraform" }
}
```

Outputs: `url` (`REGION-docker.pkg.dev/PROJECT/REPO`), `id`, `kms_key`.

Requires the Autokey config on the project's folder (glitch-lz 2-security) and the Artifact
Registry + Cloud KMS APIs in the project.

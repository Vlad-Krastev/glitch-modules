terraform {
  required_version = ">= 1.9"
}

module "web" {
  source = "../.."

  project_id    = "my-app-dev"
  name          = "my-app-web"
  image         = "europe-west3-docker.pkg.dev/my-app-dev/app/web@sha256:0000000000000000000000000000000000000000000000000000000000000000"
  max_instances = 1
  access        = "firebase" # the app authenticates every request itself
  env           = { PUBLIC_ORIGIN = "https://app.example.com" }

  deletion_protection = false # dev
  labels              = { app = "my-app", env = "dev", owner = "glitch", managed_by = "terraform" }
}

output "service" {
  value = module.web.name
}

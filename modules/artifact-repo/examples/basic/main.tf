terraform {
  required_version = ">= 1.9"
}

module "images" {
  source = "../.."

  project_id    = "my-app-dev"
  repository_id = "app"
  description   = "Container images for my-app"
  writers       = ["serviceAccount:deployer@my-app-dev.iam.gserviceaccount.com"]
  labels        = { app = "my-app", env = "dev", owner = "glitch", managed_by = "terraform" }
}

output "image_base" {
  value = module.images.url
}

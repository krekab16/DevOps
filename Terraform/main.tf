terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

module "terraform-nodejs-app" {
  source = "./modules/terraform-nodejs-app/docker"
  
  app_port = var.app_port
  container_name = "terraform-nodejs-sample-docker"

}
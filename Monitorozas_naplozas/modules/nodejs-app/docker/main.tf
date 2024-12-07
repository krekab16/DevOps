terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

resource "docker_image" "node_app" {
  name = "node-sample-app:latest"
  build {
    context    = "."
    dockerfile = "Dockerfile_deploy-env"
    tag        = ["node-sample-app:latest"]
    no_cache   = true
  }
}

resource "docker_container" "node_app" {
  count = var.container_count
  name  = "${var.container_name}-${count.index + 1}"
  hostname = "${var.container_name}-${count.index + 1}"
  image = docker_image.node_app.image_id

  memory = var.memory_limit
  
  restart = var.restart_policy
  
  ports {
    internal = var.app_port
    external = var.app_port + count.index
  }
  
  networks_advanced {
    name = var.network
    aliases = ["${var.container_name}-${count.index + 1}"]
    ipv4_address = "172.18.0.${20 + count.index}"
  }
  
  dynamic "healthcheck" {
    for_each = var.healthcheck.enabled ? [1] : []
    content {
      test         = var.healthcheck.test
      interval     = var.healthcheck.interval
      timeout      = var.healthcheck.timeout
      retries      = var.healthcheck.retries
      start_period = var.healthcheck.start_period
    }
  }
}

output "container_name" {
  value = var.container_name
}
resource "kubernetes_deployment_v1" "myapp1" {
  metadata {
    name = "flaskapp-aws-microservice"
    labels = {
      app = "flaskapp-aws-restapp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "flaskapp-aws-restapp"
      }
    }

    template {
      metadata {
        name = "flaskapp-aws-restapp-pod"
        labels = {
          app = "flaskapp-aws-restapp"
        }
      }

      spec {
        container {
          image = "${var.docker_image_name}:${var.docker_image_tag}"
          name  = "flaskapp-aws-restapp"
          port {
            container_port = 5000
          }
          env {
            name = "DB_HOSTNAME"
            value = var.db_hostname
          }
          env {
            name = "DB_PORT"
            value = data.aws_db_instance.database1.port
          }
          env {
            name = "DB_NAME"
            value = data.aws_db_instance.database1.db_name
          }
          env {
            name = "DB_USERNAME"
            value = data.aws_db_instance.database1.master_username
          }
          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.products_secret.metadata.0.name
                key = "db-password"
              }
            }
          }
        }
      }
    }
  }
}
resource "kubernetes_service_v1" "postgresql_service" {
  metadata {
    name = "postgresql"
  }
  spec {
    type = "ExternalName"
    external_name = data.aws_db_instance.database1.address
  }
}
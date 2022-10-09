resource "kubernetes_secret_v1" "products_secret" {
  metadata {
    name = "postgresql-db-password"
  }
  type = "Opaque"
  data = {
    db-password = base64decode(var.db_password_64encoded)
  }
}
resource "kubernetes_service_v1" "myapp1_np_service" {
  metadata {
    name = "flaskapp-clusterip-service"
    annotations = {
      "alb.ingress.kubernetes.io/healthcheck-path" = "/details"
    }
  }

  spec {
    selector = {
      app = kubernetes_deployment_v1.myapp1.spec.0.selector.0.match_labels.app
    }
    port {
      name = "http"
      port = 80
      target_port = 5000
    }
    type = "NodePort"
  }
}
# Type: Load Balancer - 
resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = "ingress-external-dns"
    annotations = {
      "alb.ingress.kubernetes.io/load-balancer-name" = "ingress-external-dns"
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP"
      "alb.ingress.kubernetes.io/healthcheck-port" = "traffic-port"
      # "alb.ingress.kubernetes.io/healthcheck-path" = "/details"
      "alb.ingress.kubernetes.io/healthcheck-interval-seconds" = 15
      "alb.ingress.kubernetes.io/healthcheck-timeout-seconds" = 5
      "alb.ingress.kubernetes.io/success-codes" = 200
      "alb.ingress.kubernetes.io/healthy-threshold-count" = 2
      "alb.ingress.kubernetes.io/unhealthy-threshold-count" = 2
      "alb.ingress.kubernetes.io/listen-ports": jsonencode([{"HTTPS" = 443}, {"HTTP" = 80}])
      "alb.ingress.kubernetes.io/certificate-arn": data.aws_acm_certificate.issued.arn
      "alb.ingress.kubernetes.io/ssl-redirect": 443
      # External DNS - For creating a Record Set in Route53
      "external-dns.alpha.kubernetes.io/hostname": "api.seseri.co"
    }
  }
  spec {
    ingress_class_name = "my-aws-ingress-class"
    default_backend {
      service {
        name = kubernetes_service_v1.myapp1_np_service.metadata[0].name

        port {
          number = 80
        }
      }
    }
  }
}
resource "kubernetes_namespace" "headlamp" {
    metadata {
        name = var.namespace
    }
}

resource "helm_release" "headlamp" {
    namespace  = kubernetes_namespace.headlamp.metadata[0].name
    name       = "headlamp"
    repository = "https://headlamp-k8s.github.io/headlamp"
    chart      = "headlamp"
    version    = var.headlamp_version
    values     = [
        <<-EOT
        ingress:
          enabled: true
          hosts:
            - host: ${var.host}
              paths:
                - path: /
                  type: Prefix
        EOT
    , var.ingress_class == null ? "" : <<-EOT
        ingress:
          annotations:
            kubernetes.io/ingress.class: ${var.ingress_class}
        EOT
    , var.issuer_name == null ? "" : <<-EOT
        ingress:
          annotations:
            cert-manager.io/${var.issuer_type}: ${var.issuer_name}
          tls:
            - secretName: headlamp-tls
              hosts:
                - ${var.host}
        EOT
    ]
}

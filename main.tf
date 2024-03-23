resource "kubernetes_namespace" "headlamp" {
    metadata {
        name = var.namespace
    }
}

locals {
    configure_ingress = var.host != null
}

resource "helm_release" "headlamp" {
    namespace  = kubernetes_namespace.headlamp.metadata[0].name
    name       = "headlamp"
    repository = "https://headlamp-k8s.github.io/headlamp"
    chart      = "headlamp"
    version    = var.headlamp_version
    values     = [
        !local.configure_ingress ? "" : <<-EOT1
        ingress:
          enabled: true
          hosts:
            - host: ${var.host}
              paths:
                - path: /
                  type: Prefix
        EOT1
    ,
        !local.configure_ingress || var.ingress_class == null ? "" : <<-EOT2
        ingress:
          annotations:
            kubernetes.io/ingress.class: ${var.ingress_class}
        EOT2
    ,
        !local.configure_ingress || var.issuer_name == null ? "" : <<-EOT3
        config:
          oidc:
            issuerURL: "${var.oidc_issuer_url}"
            clientID: "${var.oidc_client_id}"
            clientSecret: "${var.oidc_client_secret}"
            scopes: "${var.oidc_scopes}"
        ingress:
          annotations:
            cert-manager.io/${var.issuer_type}: ${var.issuer_name}
          tls:
            - secretName: headlamp-tls
              hosts:
                - ${var.host}
        EOT3
    ]
}

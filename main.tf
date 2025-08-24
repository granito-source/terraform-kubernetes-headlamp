locals {
    configure_ingress = var.host != null
}

resource "kubernetes_namespace_v1" "headlamp" {
    metadata {
        name = var.namespace
    }
}

resource "helm_release" "headlamp" {
    namespace  = kubernetes_namespace_v1.headlamp.metadata[0].name
    name       = "headlamp"
    repository = "https://kubernetes-sigs.github.io/headlamp"
    chart      = "headlamp"
    version    = var.headlamp_version
    values     = [
        <<EOT
%{ if local.configure_ingress ~}
ingress:
  enabled: true
  annotations: {
%{ if var.issuer_name != null ~}
    cert-manager.io/${var.issuer_type}: ${var.issuer_name}
%{ endif ~}
%{ if var.ingress_class != null ~}
    kubernetes.io/ingress.class: ${var.ingress_class}
%{ endif ~}
  }
  hosts:
    - host: ${var.host}
      paths:
        - path: /
          type: Prefix
%{ if var.issuer_name != null ~}
  tls:
    - secretName: headlamp-tls
      hosts:
        - ${var.host}
config:
  oidc:
    issuerURL: "${var.oidc_issuer_url}"
    clientID: "${var.oidc_client_id}"
    clientSecret: "${var.oidc_client_secret}"
    scopes: "${var.oidc_scopes}"
%{ endif ~}
%{ endif ~}
EOT
    ]
}

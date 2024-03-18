locals {
    protocol = var.issuer_name == null ? "http" : "https"
}

output "url" {
    depends_on  = [helm_release.headlamp]
    value       = "${local.protocol}://${var.host}/"
    description = "installed application URL"
}

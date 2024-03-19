variable "namespace" {
    type        = string
    default     = "headlamp"
    description = "namespace to use for the installation"
}

variable "headlamp_version" {
    type        = string
    default     = null
    description = "override the Headlamp Helm chart version"
}

variable "host" {
    type        = string
    description = "FQDN for the ingress"
}

variable "ingress_class" {
    type        = string
    default     = null
    description = "ingress class to use"
}

variable "issuer_name" {
    type        = string
    default     = null
    description = "cert-manager issuer, use TLS if defined"
}

variable "issuer_type" {
    type        = string
    default     = "cluster-issuer"
    description = "cert-manager issuer type"
    validation {
        condition     = contains(["cluster-issuer", "issuer"], var.issuer_type)
        error_message = "issuer type must be 'issuer' or 'cluster-issuer'"
    }
}

variable "oidc_issuer" {
    type        = string
    default     = ""
    description = "OIDC issuer URL"
}

variable "oidc_client_id" {
    type        = string
    default     = ""
    description = "OIDC client ID"
}

variable "oidc_client_secret" {
    type        = string
    default     = ""
    description = "OIDC client secret"
}

variable "oidc_scopes" {
    type        = string
    default     = ""
    description = "OIDC scopes"
}

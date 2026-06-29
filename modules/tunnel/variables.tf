variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "tunnel_name" {
  description = "Name of the Cloudflare Tunnel (e.g., 'k8s-prod', 'k8s-stage')"
  type        = string
}

variable "ingress_routes" {
  description = "List of ingress routes for the tunnel"
  type = list(object({
    hostname           = string
    service            = string
    origin_server_name = string
  }))
}

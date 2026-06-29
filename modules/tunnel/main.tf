# Cloudflare Tunnel module
# Creates a tunnel with automatic secret generation and ingress routing

# Generate tunnel secret - 32 bytes as required by Cloudflare
resource "random_bytes" "tunnel_secret" {
  length = 32

  lifecycle {
    prevent_destroy = true
  }
}

# Create the Cloudflare Tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id    = var.account_id
  name          = var.tunnel_name
  config_src    = "cloudflare"
  tunnel_secret = random_bytes.tunnel_secret.base64

  lifecycle {
    prevent_destroy = true
  }
}

# Configure tunnel ingress routing
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "config" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id

  config = {
    ingress = concat(
      [
        for route in var.ingress_routes : {
          hostname = route.hostname
          service  = route.service
          origin_request = {
            origin_server_name = route.origin_server_name
            http2_origin       = true
          }
        }
      ],
      [
        # Catch-all rule for unmatched traffic
        {
          service = "http_status:404"
        }
      ]
    )
  }
}

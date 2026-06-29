# Output tunnel credentials and metadata

output "tunnel_id" {
  description = "The ID of the Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
}

output "tunnel_secret" {
  description = "The tunnel secret (base64) for constructing cloudflared credentials"
  value       = random_bytes.tunnel_secret.base64
  sensitive   = true
}

output "tunnel_cname" {
  description = "The CNAME target for DNS records"
  value       = "${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.cfargotunnel.com"
}

# Output tunnel credentials and metadata

output "tunnel_id" {
  description = "The ID of the Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
}

output "tunnel_token" {
  description = "The tunnel token for cloudflared deployment"
  value       = cloudflare_zero_trust_tunnel_cloudflared.tunnel.tunnel_token
  sensitive   = true
}

output "tunnel_cname" {
  description = "The CNAME target for DNS records"
  value       = "${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.cfargotunnel.com"
}

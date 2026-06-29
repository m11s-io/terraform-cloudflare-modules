# Output tunnel credentials and metadata

output "tunnel_id" {
  description = "The ID of the Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
}

output "tunnel_token" {
  description = "The tunnel token for cloudflared deployment"
  value = base64encode(templatefile("${path.root}/tunnel-token.json.tpl", {
    account_id    = var.account_id
    tunnel_id     = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
    tunnel_secret = random_bytes.tunnel_secret.base64
  }))
  sensitive = true
}

output "tunnel_cname" {
  description = "The CNAME target for DNS records"
  value       = "${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.cfargotunnel.com"
}

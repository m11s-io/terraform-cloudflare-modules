# tunnel

Creates a Cloudflare Zero Trust tunnel with automatic secret generation and ingress routing rules.

## What it does

- Generates a cryptographically random 32-byte tunnel secret (lifecycle-protected)
- Creates a `cloudflare_zero_trust_tunnel_cloudflared` resource
- Configures ingress routing with a catch-all `http_status:404` fallback
- Outputs the tunnel ID, secret, and CNAME target for DNS wiring

## Usage

```hcl
module "tunnel" {
  source  = "m11s-io/modules/cloudflare//modules/tunnel"
  version = "~> 0.1"

  account_id  = var.cloudflare_account_id
  tunnel_name = "k8s-prod"

  ingress_routes = [
    {
      hostname           = "*.example.com"
      service            = "http://traefik.traefik.svc.cluster.local:80"
      origin_server_name = "traefik.traefik.svc.cluster.local"
    }
  ]
}

# Wire DNS
resource "cloudflare_dns_record" "wildcard" {
  zone_id = var.zone_id
  name    = "*.example.com"
  content = module.tunnel.tunnel_cname
  type    = "CNAME"
  proxied = true
}
```

## Inputs

| Name | Type | Description |
|---|---|---|
| `account_id` | `string` | Cloudflare account ID |
| `tunnel_name` | `string` | Tunnel name (e.g. `k8s-prod`) |
| `ingress_routes` | `list(object)` | List of `hostname`, `service`, `origin_server_name` |

## Outputs

| Name | Description |
|---|---|
| `tunnel_id` | Tunnel ID |
| `tunnel_secret` | Raw base64 secret for cloudflared credentials (sensitive) |
| `tunnel_cname` | CNAME target for DNS records (`<id>.cfargotunnel.com`) |

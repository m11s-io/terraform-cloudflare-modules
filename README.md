# terraform-cloudflare-modules

OpenTofu/Terraform modules for Cloudflare infrastructure.

## Modules

### `modules/tunnel`

Creates a Cloudflare Zero Trust tunnel with automatic secret generation and ingress routing.

**Resources:** `cloudflare_zero_trust_tunnel_cloudflared`, `cloudflare_zero_trust_tunnel_cloudflared_config`, `random_bytes`

```hcl
module "tunnel" {
  source = "github.com/m11s-io/terraform-cloudflare-modules//modules/tunnel"

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
```

| Variable | Type | Description |
|---|---|---|
| `account_id` | `string` | Cloudflare account ID |
| `tunnel_name` | `string` | Tunnel name (e.g. `k8s-prod`) |
| `ingress_routes` | `list(object)` | Routes: `hostname`, `service`, `origin_server_name` |

| Output | Description |
|---|---|
| `tunnel_id` | Tunnel ID |
| `tunnel_token` | Token for cloudflared deployment (sensitive) |
| `tunnel_cname` | CNAME target for DNS records (`<id>.cfargotunnel.com`) |

---

### `modules/email-routing`

Enables Cloudflare Email Routing for a zone — forwarding rules, catch-all, and DMARC record.

**Resources:** `cloudflare_email_routing_settings`, `cloudflare_email_routing_dns`, `cloudflare_email_routing_rule`, `cloudflare_email_routing_catch_all`, `cloudflare_dns_record` (DMARC)

```hcl
module "email_routing" {
  source = "github.com/m11s-io/terraform-cloudflare-modules//modules/email-routing"

  zone_id         = var.zone_id
  domain          = "example.com"
  catch_all_email = "inbox@example.com"
  dmarc_rua_ids   = ["abc123"]

  rules = {
    "hello" = "hello@other.com"
    "support" = "support@other.com"
  }
}
```

| Variable | Type | Default | Description |
|---|---|---|---|
| `zone_id` | `string` | | Cloudflare zone ID |
| `domain` | `string` | | Apex domain |
| `catch_all_email` | `string` | | Catch-all forwarding address |
| `dmarc_rua_ids` | `list(string)` | | Cloudflare DMARC report URI identifiers |
| `dmarc_wrap_in_quotes` | `bool` | `false` | Wrap DMARC content in literal quotes |
| `rules` | `map(string)` | `{}` | Map of `local-part` → destination email |

---

### `modules/forthwall-shop`

DNS records for a [Fourthwall](https://fourthwall.com) shop on a custom domain — shop A record, Zendesk support subdomain, and SendGrid email authentication.

**Resources:** `cloudflare_dns_record` (A, CNAME, MX, TXT)

```hcl
module "forthwall_shop" {
  source = "github.com/m11s-io/terraform-cloudflare-modules//modules/forthwall-shop"

  zone_id                    = var.zone_id
  domain                     = "example.com"
  zendesk_verification_token = "abc123"
  sendgrid_subuser           = "u12345678.wl001"
}
```

| Variable | Type | Default | Description |
|---|---|---|---|
| `zone_id` | `string` | | Cloudflare zone ID |
| `domain` | `string` | | Apex domain |
| `shop_ip` | `string` | `34.117.223.165` | Fourthwall origin IP |
| `zendesk_verification_token` | `string` | | Zendesk domain verification token |
| `sendgrid_subuser` | `string` | | SendGrid subuser ID |

DNS records created under `shop.<domain>`:
- `shop.<domain>` → A record (Fourthwall origin)
- `www.shop.<domain>` → CNAME
- `support.shop.<domain>` → MX (Fourthwall), SPF, DMARC, Zendesk CNAME/DKIM, SendGrid CNAME/DKIM

## Requirements

| Name | Version |
|---|---|
| opentofu / terraform | >= 1.8 |
| cloudflare/cloudflare | ~> 5.0 |
| hashicorp/random | ~> 3.1 |

## License

MIT

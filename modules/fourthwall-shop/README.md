# fourthwall-shop

DNS records for a [Fourthwall](https://fourthwall.com) shop on a custom domain, including Zendesk support subdomain and SendGrid transactional email authentication.

## What it does

Sets up the following DNS records under `shop.<domain>`:

- `shop.<domain>` → A record pointing to the Fourthwall origin
- `www.shop.<domain>` → CNAME to `shop.<domain>`
- `support.shop.<domain>` → MX records (Fourthwall mail servers)
- `support.shop.<domain>` → SPF TXT (Google, Zendesk, Fourthwall, SendGrid)
- `support.shop.<domain>` → DMARC TXT
- Zendesk domain verification, routing CNAMEs, and DKIM records
- SendGrid CNAME and DKIM records for transactional email

## Usage

```hcl
module "shop" {
  source  = "m11s-io/modules/cloudflare//modules/fourthwall-shop"
  version = "~> 0.1"

  zone_id                    = cloudflare_zone.example.id
  domain                     = "example.com"
  shop_ip                    = "34.117.223.165"
  zendesk_verification_token = "your-zendesk-token"
  sendgrid_subuser           = "u12345678.wl001"
}
```

## Inputs

| Name | Type | Description |
|---|---|---|
| `zone_id` | `string` | Cloudflare zone ID |
| `domain` | `string` | Apex domain (e.g. `example.com`) |
| `shop_ip` | `string` | Fourthwall origin IP for the shop A record |
| `zendesk_verification_token` | `string` | Zendesk domain verification token for `support.shop` |
| `sendgrid_subuser` | `string` | SendGrid subuser ID (e.g. `u12345678.wl001`) |

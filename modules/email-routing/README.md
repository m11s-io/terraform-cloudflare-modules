# email-routing

Enables Cloudflare Email Routing for a zone with forwarding rules, catch-all, and DMARC record.

## What it does

- Enables Email Routing on the zone
- Provisions required Cloudflare DNS records for email routing
- Creates per-address forwarding rules (e.g. `hello@example.com` → `hello@other.com`)
- Creates a catch-all rule forwarding all unmatched addresses to a single destination
- Creates a `_dmarc` TXT record using Cloudflare DMARC Management reporting

## Usage

```hcl
module "email_routing" {
  source  = "m11s-io/modules/cloudflare//modules/email-routing"
  version = "~> 0.1"

  zone_id         = cloudflare_zone.example.id
  domain          = "example.com"
  catch_all_email = "inbox@example.com"
  dmarc_rua_ids   = ["abc123def456"]

  rules = {
    hello   = "hello@other.com"
    support = "support@other.com"
  }
}
```

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `zone_id` | `string` | | Cloudflare zone ID |
| `domain` | `string` | | Apex domain (e.g. `example.com`) |
| `catch_all_email` | `string` | | Destination for all unmatched addresses |
| `dmarc_rua_ids` | `list(string)` | | Cloudflare DMARC Management report URI identifiers |
| `dmarc_wrap_in_quotes` | `bool` | `false` | Wrap DMARC TXT value in literal quotes (required by some providers) |
| `rules` | `map(string)` | `{}` | Map of `local-part` → destination email for specific addresses |

# Forthwall shop DNS records
# Manages shop.<domain>, www.shop.<domain>, and support.shop.<domain> (Zendesk + SendGrid)

locals {
  shop    = "shop.${var.domain}"
  support = "support.shop.${var.domain}"
}

resource "cloudflare_dns_record" "shop_a" {
  zone_id = var.zone_id
  name    = local.shop
  content = var.shop_ip
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "www_shop_cname" {
  zone_id = var.zone_id
  name    = "www.${local.shop}"
  content = local.shop
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

# support.shop — MX
resource "cloudflare_dns_record" "support_mx1" {
  zone_id  = var.zone_id
  name     = local.support
  content  = "mx1.fourthwall.com"
  type     = "MX"
  ttl      = 1
  priority = 10
}

resource "cloudflare_dns_record" "support_mx2" {
  zone_id  = var.zone_id
  name     = local.support
  content  = "mx2.fourthwall.com"
  type     = "MX"
  ttl      = 1
  priority = 20
}

# support.shop — SPF + DMARC
resource "cloudflare_dns_record" "support_spf_txt" {
  zone_id = var.zone_id
  name    = local.support
  content = "v=spf1 include:_spf.google.com include:mail.zendesk.com include:spf.fourthwall.com include:sendgrid.net ~all"
  type    = "TXT"
  ttl     = 1
}

resource "cloudflare_dns_record" "support_dmarc_txt" {
  zone_id = var.zone_id
  name    = "_dmarc.${local.support}"
  content = "v=DMARC1; p=reject; pct=100; rua=mailto:dmarc@fourthwall.com"
  type    = "TXT"
  ttl     = 1
}

# support.shop — Zendesk routing
resource "cloudflare_dns_record" "support_zendesk_verification_txt" {
  zone_id = var.zone_id
  name    = "zendeskverification.${local.support}"
  content = var.zendesk_verification_token
  type    = "TXT"
  ttl     = 1
}

resource "cloudflare_dns_record" "support_zendesk1_cname" {
  zone_id = var.zone_id
  name    = "zendesk1.${local.support}"
  content = "mail1.zendesk.com"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "support_zendesk2_cname" {
  zone_id = var.zone_id
  name    = "zendesk2.${local.support}"
  content = "mail2.zendesk.com"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "support_zendesk3_cname" {
  zone_id = var.zone_id
  name    = "zendesk3.${local.support}"
  content = "mail3.zendesk.com"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "support_zendesk4_cname" {
  zone_id = var.zone_id
  name    = "zendesk4.${local.support}"
  content = "mail4.zendesk.com"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "support_zendesk1_domainkey_cname" {
  zone_id = var.zone_id
  name    = "zendesk1._domainkey.${local.support}"
  content = "zendesk1._domainkey.zendesk.com"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "support_zendesk2_domainkey_cname" {
  zone_id = var.zone_id
  name    = "zendesk2._domainkey.${local.support}"
  content = "zendesk2._domainkey.zendesk.com"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

# support.shop — SendGrid
resource "cloudflare_dns_record" "support_em_fw_cname" {
  zone_id = var.zone_id
  name    = "em-fw.${local.support}"
  content = "${var.sendgrid_subuser}.sendgrid.net"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "support_s1_domainkey_cname" {
  zone_id = var.zone_id
  name    = "s1._domainkey.${local.support}"
  content = "s1.domainkey.${var.sendgrid_subuser}.sendgrid.net"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "support_s2_domainkey_cname" {
  zone_id = var.zone_id
  name    = "s2._domainkey.${local.support}"
  content = "s2.domainkey.${var.sendgrid_subuser}.sendgrid.net"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

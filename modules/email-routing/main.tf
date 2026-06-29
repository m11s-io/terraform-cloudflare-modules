resource "cloudflare_email_routing_settings" "this" {
  zone_id = var.zone_id
}

resource "cloudflare_email_routing_dns" "this" {
  zone_id = var.zone_id
}

resource "cloudflare_email_routing_rule" "this" {
  for_each = var.rules
  zone_id  = var.zone_id
  name     = "Forward ${each.key}@"
  enabled  = true
  matchers = [{
    type  = "literal"
    field = "to"
    value = "${each.key}@${var.domain}"
  }]
  actions = [{
    type  = "forward"
    value = [each.value]
  }]
}

# DMARC record managed by Cloudflare DMARC Management (enabled via dashboard)
locals {
  dmarc_content = "v=DMARC1; p=none; rua=${join(",", [for rua_id in var.dmarc_rua_ids : "mailto:${rua_id}@dmarc-reports.cloudflare.net"])}"
}

resource "cloudflare_dns_record" "dmarc" {
  zone_id = var.zone_id
  name    = "_dmarc.${var.domain}"
  content = var.dmarc_wrap_in_quotes ? "\"${local.dmarc_content}\"" : local.dmarc_content
  type    = "TXT"
  ttl     = 1
  proxied = false
}

resource "cloudflare_email_routing_catch_all" "this" {
  zone_id = var.zone_id
  name    = "Catch-all forward"
  enabled = true
  matchers = [{
    type = "all"
  }]
  actions = [{
    type  = "forward"
    value = [var.catch_all_email]
  }]
}

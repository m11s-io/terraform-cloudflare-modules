variable "zone_id" {
  description = "Cloudflare zone ID"
  type        = string
}

variable "domain" {
  description = "Apex domain (e.g. example.com)"
  type        = string
}

variable "shop_ip" {
  description = "Forthwall origin IP for the shop A record"
  type        = string
}

variable "zendesk_verification_token" {
  description = "Zendesk domain verification token for support.shop"
  type        = string
}

variable "sendgrid_subuser" {
  description = "SendGrid subuser ID (e.g. u58912580.wl081)"
  type        = string
}

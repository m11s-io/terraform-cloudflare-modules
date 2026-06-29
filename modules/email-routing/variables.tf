variable "zone_id" {
  description = "Cloudflare zone ID"
  type        = string
}

variable "domain" {
  description = "Domain name (e.g., 'm11s.io', 'workanoo.com')"
  type        = string
}

variable "catch_all_email" {
  description = "Forwarding target email address for catch-all rule"
  type        = string
}

variable "dmarc_rua_ids" {
  description = "Cloudflare DMARC Management report URI identifiers for the zone"
  type        = list(string)
}

variable "dmarc_wrap_in_quotes" {
  description = "Whether the DMARC TXT content should be wrapped in literal quotes"
  type        = bool
  default     = false
}

variable "rules" {
  description = "Map of local-part to destination email for addresses that differ from catch-all"
  type        = map(string)
  default     = {}
}

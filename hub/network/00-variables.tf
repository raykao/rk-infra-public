variable prefix {
	type = string
	default = "rk"
}

variable location {
	type = string
	default = "canadacentral"
}

variable domain {
	type = string
}

variable "vpn_sku" {
  type = string
  default = "VpnGw1AZ"
}
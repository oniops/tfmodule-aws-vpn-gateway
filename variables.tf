################################################################################
### Customer Gateway
################################################################################

variable "create_cgw" {
  type    = bool
  default = true
}

variable "gateway_name" {
  description = "The name of customer gateway"
  type        = string
}


variable "bgp_asn" {
  description = "The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN)."
  type        = number
  default     = 65000
}

variable "ip_address" {
  description = "The IPv4 address for the customer gateway device's outside interface."
  type        = string
}

variable "type" {
  description = "The type of customer gateway. The only type AWS supports at this time is `ipsec.1`"
  type        = string
  default     = "ipsec.1"
}

variable "certificate_arn" {
  description = "The Amazon Resource Name (ARN) for the customer gateway certificate."
  type        = string
  default     = null
}

variable "device_name" {
  description = "A name for the customer gateway device."
  type        = string
  default     = null
}

################################################################################
### VPN Connections
################################################################################
variable "static_routes_only" {
  description = "Whether the VPN connection uses static routes exclusively. Static routes must be used for devices that don't support BGP."
  type        = bool
  default     = false
}

variable "outside_ip_address_type" {
  description = "Indicates if a Public S2S VPN or Private S2S VPN over AWS Direct Connect. Valid values are PublicIpv4, PrivateIpv4"
  type        = string
  default     = "PublicIpv4"
}

variable "remote_ipv4_network_cidr" {
  description = "The IPv4 CIDR on the AWS side of the VPN connection."
  type        = string
  default     = "0.0.0.0/0"
}

### options for Tunnel 1
variable "tunnel1_inside_cidr" {
  description = "The CIDR block of the inside IP addresses for the first VPN tunnel. Valid value is a size /30 CIDR block from the 169.254.0.0/16 range."
  type        = string
  default     = null
}

variable "tunnel1_startup_action" {
  description = "The action to take when the establishing the tunnel for the first VPN connection. Valid values are add | start."
  type        = string
  default     = "add"
}

variable "tunnel1_dpd_timeout_action" {
  description = "The action to take after DPD timeout occurs for the first VPN tunnel. Valid values are clear|none|restart"
  type        = string
  default     = "clear"
}

variable "tunnel1_dpd_timeout_seconds" {
  description = "The number of seconds after which a DPD timeout occurs for the first VPN tunnel. Valid value is equal or higher than 30."
  type        = number
  default     = null
}

variable "tunnel1_phase1_dh_group_numbers" {
  description = <<EOF
List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 1 IKE negotiations.
  Valid values are 2 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24.
EOF
  type        = list(string)
  default     = null
}

variable "tunnel1_phase1_encryption_algorithms" {
  description = <<EOF
List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations.
Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16.
EOF
  type        = list(string)
  default     = null
}

variable "tunnel1_phase1_integrity_algorithms" {
  description = <<EOF
One or more integrity algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations.
Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512.
EOF
  type        = list(string)
  default     = null
}

variable "tunnel1_phase1_lifetime_seconds" {
  description = "The lifetime for phase 1 of the IKE negotiation for the first VPN tunnel, in seconds. Valid value is between 900 and 28800."
  type        = string
  default     = null
}

variable "tunnel1_phase2_dh_group_numbers" {
  description = <<EOF
List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 2 IKE negotiations.
  Valid values are 2 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24.
EOF
  type        = list(string)
  default     = null
}

variable "tunnel1_phase2_encryption_algorithms" {
  description = <<EOF
List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations.
Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16.
EOF
  type        = list(string)
  default     = null
}

variable "tunnel1_phase2_integrity_algorithms" {
  description = <<EOF
List of one or more integrity algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations.
Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512.
EOF
  type        = list(string)
  default     = null
}

variable "tunnel1_phase2_lifetime_seconds" {
  description = "The lifetime for phase 2 of the IKE negotiation for the first VPN tunnel, in seconds. Valid value is between 900 and 3600."
  type        = number
  default     = null
}

### options for Tunnel 2
variable "tunnel2_inside_cidr" {
  description = "The CIDR block of the inside IP addresses for the second VPN tunnel. Valid value is a size /30 CIDR block from the 169.254.0.0/16 range."
  type        = string
  default     = null
}

variable "tunnel2_startup_action" {
  description = "The action to take when the establishing the tunnel for the second VPN connection. Valid values are add | start."
  type        = string
  default     = "add"
}

variable "tunnel2_dpd_timeout_action" {
  description = "The action to take after DPD timeout occurs for the second VPN tunnel. Valid values are clear|none|restart"
  type        = string
  default     = "clear"
}

variable "tunnel2_dpd_timeout_seconds" {
  description = "The number of seconds after which a DPD timeout occurs for the second VPN tunnel. Valid value is equal or higher than 30."
  type        = number
  default     = null
}

variable "tunnel2_phase1_dh_group_numbers" {
  description = <<EOF
List of one or more Diffie-Hellman group numbers that are permitted for the second VPN tunnel for phase 1 IKE negotiations.
  Valid values are 2 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24.
EOF
  type        = string
  default     = null
}

variable "tunnel2_phase1_encryption_algorithms" {
  description = <<EOF
List of one or more encryption algorithms that are permitted for the second VPN tunnel for phase 1 IKE negotiations.
Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16.
EOF
  type        = string
  default     = null
}

variable "tunnel2_phase1_integrity_algorithms" {
  description = <<EOF
One or more integrity algorithms that are permitted for the second VPN tunnel for phase 1 IKE negotiations.
Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512.
EOF
  type        = string
  default     = null
}

variable "tunnel2_phase1_lifetime_seconds" {
  description = "The lifetime for phase 1 of the IKE negotiation for the second VPN tunnel, in seconds. Valid value is between 900 and 28800."
  type        = string
  default     = null
}

variable "tunnel2_phase2_dh_group_numbers" {
  description = <<EOF
List of one or more Diffie-Hellman group numbers that are permitted for the second VPN tunnel for phase 2 IKE negotiations.
  Valid values are 2 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24.
EOF
  type        = string
  default     = null
}

variable "tunnel2_phase2_encryption_algorithms" {
  description = <<EOF
List of one or more encryption algorithms that are permitted for the second VPN tunnel for phase 2 IKE negotiations.
Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16.
EOF
  type        = list(string)
  default     = null
}

variable "tunnel2_phase2_integrity_algorithms" {
  description = <<EOF
List of one or more integrity algorithms that are permitted for the second VPN tunnel for phase 2 IKE negotiations.
Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512.
EOF
  type        = string
  default     = null
}

variable "tunnel2_phase2_lifetime_seconds" {
  description = "The lifetime for phase 2 of the IKE negotiation for the second VPN tunnel, in seconds. Valid value is between 900 and 3600."
  type        = number
  default     = null
}

# connect to vgw
variable "static_routes_destinations" {
  description = <<EOF
Whether the VPN connection uses static routes exclusively. Static routes must be used for devices that don't support BGP.

Ex)
  static_routes_destinations = ["10.100.0.1/32", "10.200.0.1/32"]
EOF
  type        = list(string)
  default     = []
}

variable "route_table_ids" {
  description = <<EOF
Set the routing table IDs for setting the static routing table.

Ex)
  route_table_ids = ["rtb-04c0b1313", "rtb-04c0c87441445" ]
EOF
  type        = list(string)
  default     = []
}

# connect to vgw
variable "vpn_gateway_id" {
  description = <<EOF
The ID of the Virtual Private Gateway.

if not exists vpn_gateway:
  vpn_gateway_id = ""
EOF
  type        = string
}

variable "transit_gateway_id" {
  description = <<EOF
  The ID of the EC2 Transit Gateway.

if not exists ec2_transit_gateway_gateway:
  transit_gateway_id = ""
EOF
  type        = string
}

variable "transport_transit_gateway_attachment_id" {
  description = "The attachment ID of the Transit Gateway attachment to Direct Connect Gateway."
  type        = string
  default     = null
}

variable "transit_gateway_attachment_id" {
  description = "Identifier of EC2 Transit Gateway Attachment."
  type        = string
  default     = null
}

variable "transit_gateway_route_table_id" {
  description = "Identifier of EC2 Transit Gateway Route Table."
  type        = string
  default     = null
}

variable "replace_existing_association" {
  description = "Whether the Gateway Attachment should remove any current Route Table association before associating with the specified Route Table."
  type        = bool
  default     = false
}

#variable "amazon_side_asn" {
#  description = "The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN) of Amazon side."
#  type        = string
#  default     = "64512"
#}
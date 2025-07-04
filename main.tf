locals {
  name_prefix         = var.context.name_prefix
  region              = var.context.region
  tags                = var.context.tags
  create_cgw          = var.create_cgw
  cgw_name            = "${local.name_prefix}-${var.gateway_name}-cgw"
  cgw_connection_name = "${local.cgw_name}-conn"

  transport_transit_gateway_attachment_id = (var.outside_ip_address_type == "PrivateIpv4" ? var.outside_ip_address_type : var.transport_transit_gateway_attachment_id)

  vpn_gateway_id              = length(var.vpn_gateway_id) > 3 ? var.vpn_gateway_id : null
  transit_gateway_id          = length(var.vpn_gateway_id) > 3 ? null : var.transit_gateway_id
  connect_to_vgw              = local.create_cgw && local.vpn_gateway_id != null ? true : false
  connect_to_tgw              = local.create_cgw && local.transit_gateway_id != null ? true : false
  static_routes_count         = var.static_routes_only ? length(var.static_routes_destinations) : 0
  enable_cloudwatch_log_group = var.enable_log_tunnel1 || var.enable_log_tunnel2
}

resource "aws_customer_gateway" "this" {
  count           = local.create_cgw ? 1 : 0
  bgp_asn         = var.bgp_asn
  ip_address      = var.ip_address
  type            = var.type
  certificate_arn = var.certificate_arn
  device_name     = var.device_name
  tags = merge(local.tags, {
    Name = local.cgw_name
  })
}

resource "aws_vpn_connection" "this" {
  count                    = local.create_cgw ? 1 : 0
  customer_gateway_id      = aws_customer_gateway.this[0].id
  type                     = aws_customer_gateway.this[0].type
  outside_ip_address_type  = var.outside_ip_address_type
  remote_ipv4_network_cidr = var.remote_ipv4_network_cidr
  static_routes_only = var.static_routes_only

  # Tunnel 1
  tunnel1_inside_cidr                  = var.tunnel1_inside_cidr
  tunnel1_startup_action               = var.tunnel1_startup_action
  tunnel1_dpd_timeout_action           = var.tunnel1_dpd_timeout_action
  tunnel1_dpd_timeout_seconds          = var.tunnel1_dpd_timeout_seconds
  tunnel1_phase1_dh_group_numbers      = var.tunnel1_phase1_dh_group_numbers
  tunnel1_phase1_encryption_algorithms = var.tunnel1_phase1_encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = var.tunnel1_phase1_integrity_algorithms
  tunnel1_phase1_lifetime_seconds      = var.tunnel1_phase1_lifetime_seconds
  tunnel1_phase2_dh_group_numbers      = var.tunnel1_phase2_dh_group_numbers
  tunnel1_phase2_encryption_algorithms = var.tunnel1_phase2_encryption_algorithms
  tunnel1_phase2_integrity_algorithms  = var.tunnel1_phase2_integrity_algorithms
  tunnel1_phase2_lifetime_seconds      = var.tunnel1_phase2_lifetime_seconds

  dynamic "tunnel1_log_options" {
    for_each = var.enable_log_tunnel1 ? [true] : []
    content {
      cloudwatch_log_options {
        log_enabled       = var.enable_log_tunnel1
        log_group_arn = try(aws_cloudwatch_log_group.this[0].arn, "")
        log_output_format = var.cloudwatch_log_format
      }
    }
  }

  # Tunnel 2
  tunnel2_inside_cidr                  = var.tunnel1_inside_cidr
  tunnel2_startup_action               = var.tunnel1_startup_action
  tunnel2_dpd_timeout_action           = var.tunnel1_dpd_timeout_action
  tunnel2_dpd_timeout_seconds          = var.tunnel1_dpd_timeout_seconds
  tunnel2_phase1_dh_group_numbers      = var.tunnel1_phase1_dh_group_numbers
  tunnel2_phase1_encryption_algorithms = var.tunnel1_phase1_encryption_algorithms
  tunnel2_phase1_integrity_algorithms  = var.tunnel1_phase1_integrity_algorithms
  tunnel2_phase1_lifetime_seconds      = var.tunnel1_phase1_lifetime_seconds
  tunnel2_phase2_dh_group_numbers      = var.tunnel1_phase2_dh_group_numbers
  tunnel2_phase2_encryption_algorithms = var.tunnel1_phase2_encryption_algorithms
  tunnel2_phase2_integrity_algorithms  = var.tunnel1_phase2_integrity_algorithms
  tunnel2_phase2_lifetime_seconds      = var.tunnel1_phase2_lifetime_seconds

  dynamic "tunnel2_log_options" {
    for_each = var.enable_log_tunnel2 ? [true] : []
    content {
      cloudwatch_log_options {
        log_enabled       = var.enable_log_tunnel2
        log_group_arn = try(aws_cloudwatch_log_group.this[0].arn, "")
        log_output_format = var.cloudwatch_log_format
      }
    }
  }

  # VPC Gateway
  # for VGW
  vpn_gateway_id                          = local.vpn_gateway_id
  #
  # for TGW
  transit_gateway_id                      = local.transit_gateway_id
  transport_transit_gateway_attachment_id = local.transport_transit_gateway_attachment_id

  tags = merge(local.tags, {
    Name = local.cgw_connection_name
  })

  lifecycle {
    ignore_changes = [
      tunnel1_ike_versions, tunnel1_phase1_dh_group_numbers, tunnel1_phase1_encryption_algorithms,
      tunnel1_phase1_integrity_algorithms,
      tunnel1_phase2_dh_group_numbers, tunnel1_phase2_encryption_algorithms, tunnel1_phase2_integrity_algorithms,
      tunnel2_ike_versions, tunnel2_phase1_dh_group_numbers, tunnel2_phase1_encryption_algorithms,
      tunnel2_phase1_integrity_algorithms,
      tunnel2_phase2_dh_group_numbers, tunnel2_phase2_encryption_algorithms, tunnel2_phase2_integrity_algorithms,
    ]
  }
}

resource "aws_vpn_connection_route" "vgw" {
  for_each = toset(local.connect_to_vgw && local.static_routes_count > 0 ? var.static_routes_destinations : [])
  vpn_connection_id      = aws_vpn_connection.this[0].id
  destination_cidr_block = each.key
}

/*
resource "aws_ec2_transit_gateway_route_table_association" "tgw" {
  count                          = local.connect_to_tgw ?  1 : 0
  transit_gateway_attachment_id  = var.transit_gateway_attachment_id
  transit_gateway_route_table_id = var.transit_gateway_route_table_id
  replace_existing_association   = var.replace_existing_association
}
*/

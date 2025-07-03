locals {

  vgw_route_tables = distinct(flatten([
    for rt in var.route_table_ids : [
      for cidr_block in var.static_routes_destinations : {
        route_table_id         = rt
        destination_cidr_block = cidr_block
      }
    ]
  ]))

  vgw_route_table_cnt = var.create_cgw && local.static_routes_count > 0 && length(var.route_table_ids) > 0 ? length(local.vgw_route_tables) : 0
}

resource "aws_route" "vgw" {
  count                  = var.enable_route_propagation ? 0 : local.vgw_route_table_cnt
  route_table_id         = lookup(local.vgw_route_tables[count.index], "route_table_id" )
  destination_cidr_block = lookup(local.vgw_route_tables[count.index], "destination_cidr_block" )
  gateway_id             = local.vpn_gateway_id
  timeouts {
    create = "5m"
  }
}

resource "aws_vpn_gateway_route_propagation" "vgw" {
  for_each       =  var.enable_route_propagation ? var.route_table_ids: []
  vpn_gateway_id = local.vpn_gateway_id
  route_table_id = each.key

  depends_on = [aws_route.vgw]
}
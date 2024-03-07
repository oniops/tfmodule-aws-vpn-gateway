locals {

  vgw_route_tables = distinct(flatten([
    for rt in var.route_table_ids : [
      for cidr_block in var.static_routes_destinations : {
        route_table_id         = rt
        destination_cidr_block = cidr_block
      }
    ]
  ]))

  vgw_route_table_cnt = local.connect_to_vgw && local.static_routes_count > 0 && length(var.route_table_ids) > 0 ? length(local.vgw_route_tables) : 0
}

resource "aws_route" "vgw" {
  count                  = local.vgw_route_table_cnt
  route_table_id         = lookup(local.vgw_route_tables[count.index], "route_table_id" )
  destination_cidr_block = lookup(local.vgw_route_tables[count.index], "destination_cidr_block" )
  gateway_id             = local.vpn_gateway_id
  timeouts {
    create = "5m"
  }
}

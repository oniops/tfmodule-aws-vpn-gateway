locals {
  vgw_route_tables = {
    for pair in setproduct(var.route_table_ids, var.static_routes_destinations) :
    "${pair[0]}-${pair[1]}" => {
      route_table_id         = pair[0]
      destination_cidr_block = pair[1]
    }
  }
}


resource "aws_route" "vgw" {
  for_each               = var.create_cgw && length(coalesce(local.vgw_route_tables, {})) > 0 ? local.vgw_route_tables : {}
  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr_block
  gateway_id             = local.vpn_gateway_id
  timeouts {
    create = "5m"
  }
}
# tfmodule-aws-vpn-gateway

AWS VPN Gateway 네트워크 연결을 구성하는 테라폼 모듈 입니다.

## Usage

```hcl
module "ctx" {
  source = "git::https://github.com/oniops/tfmodule-context.git?ref=v1.3.3"
  context = {
    project     = "demo"
    region      = "ap-northeast-2"
    environment = "Development"
    department  = "DevOps"
    owner       = "demo@example.com"
    customer    = "Example, Org"
    domain      = "example.com"
    pri_domain  = "example.internal"
  }
}

module "vgw" {
  source                     = "git::https://github.com/oniops/tfmodule-aws-vpn-gateway.git"
  context                    = module.ctx.context
  gateway_name               = "example"
  ip_address                 = "220.15.1.101"
  static_routes_only         = true
  static_routes_destinations = ["192.168.16.0/24", "192.168.16.1/24"]
  route_table_ids            = ["rtb-04c0b393c", "rtb-0858ecd85c56",]
  vpn_gateway_id             = "vgw-0766a34141255" # Set this value when connecting to VGW.
  transit_gateway_id         = ""                  # Set this value when connecting to TGW.
}
```

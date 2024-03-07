# tfmodule-aws-vpn-gateway

AWS VPN Gateway 네트워크 연결을 구성하는 테라폼 모듈 입니다.

## Usage

```hcl
locals {
  context = {
    region      = "ap-northeast-2"
    project     = "demo"
    name_prefix = "demo-an2t"
    pri_domain  = "my.local"
    tags        = {
      Project = "demo"
    }
  }
}

module "vgw" {
  source                     = "git::https://code.bespinglobal.com/scm/op/tfmodule-aws-vpn-gateway.git"
  context                    = local.context
  gateway_name               = "vnf13"
  ip_address                 = "51.150.01.101"
  static_routes_only         = true
  static_routes_destinations = ["10.30.76.0/24", "10.30.76.1/24"]
  route_table_ids            = ["rtb-04c0b393c",]
  vpn_gateway_id             = "vgw-0766a34141255" # Set this value when connecting to VGW.
  transit_gateway_id         = ""                  # Set this value when connecting to TGW.
}

```

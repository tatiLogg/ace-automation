
data "terraform_remote_state" "lab1" {
  backend = "remote"
  config = {
    Organization = "AVXUseCases"
    workspaces = {
      name = "ace-automation-lab1"
    }
  }
}


module "backbone" {
  source  = "terraform-aviatrix-modules/backbone/aviatrix"
  version = "8.0.0"
  global_settings = {
    transit_ha_gw = false
  }
  transit_firenet = {
    aws_us_east_1 = {
      transit_name        = "transit-aws-us-east-1"
      transit_account     = var.account_name_aws
      transit_cloud       = "aws"
      transit_cidr        = "10.1.2.0/23"
      transit_region_name = "us-east-1"
      transit_asn         = 64512
    },
    aws_us_west_2 = {
      transit_name        = "transit-aws-us-west-2"
      transit_account     = var.account_name_aws
      transit_cloud       = "aws"
      transit_cidr        = "10.2.2.0/23"
      transit_region_name = "us-west-2"
      transit_asn         = 64513
    }
  }
}

resource "aviatrix_spoke_transit_attachment" "us_east_1" {
  spoke_gw_name   = data.terraform_remote_state.lab1.outputs.us_east_1_spoke.gw_name
  transit_gw_name = module.backbone.transit["aws_us_east_1"].transit_gateway.gw_name
}

resource "aviatrix_spoke_transit_attachment" "us_west_2" {
  spoke_gw_name   = data.terraform_remote_state.lab1.outputs.us_west_2_spoke.gw_name
  transit_gw_name = module.backbone.transit["aws_us_west_2"].transit_gateway.gw_name
}

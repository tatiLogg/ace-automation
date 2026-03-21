module "us_east_1_spoke" {
  source           = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version          = "8.0.0"
  cloud            = "AWS"
  name             = "spoke-aws-us-east-1"
  instance_size    = "t3.small"
  use_existing_vpc = true
  gw_subnet        = "10.1.0.16/28"
  vpc_id           = var.us_east_1_vpc_id
  region           = "us-east-1"
  account          = var.account_name_aws
  ha_gw            = false
  attached         = false
  single_ip_snat   = true
}

module "us_west_2_spoke" {
  source           = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version          = "8.0.0"
  cloud            = "AWS"
  name             = "spoke-aws-us-west-2"
  instance_size    = "t3.small"
  use_existing_vpc = true
  gw_subnet        = "10.2.0.16/28"
  vpc_id           = var.us_west_2_vpc_id
  region           = "us-west-2"
  account          = var.account_name_aws
  ha_gw            = false
  attached         = false
  single_ip_snat   = true
}

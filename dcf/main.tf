locals {
  allowed_https_domains = [    
    "aviatrix.com",
    "*.amazonaws.com",
    "cloud.google.com",
    "*.microsoft.com"]
}

resource "aviatrix_web_group" "allow_internet_https" {
  name = "allow-internet-https"
  selector {
    dynamic "match_expressions" {
      for_each = toset(local.allowed_https_domains)

      content {
        snifilter = match_expressions.value
      }
    }
  }
}

resource "aviatrix_smart_group" "rfc1918" {
  name = "rfc1918"
  selector {
    match_expressions {
      cidr = "10.0.0.0/8"
    }
    match_expressions {
      cidr = "172.16.0.0/12"
    }
    match_expressions {
      cidr = "192.168.0.0/16"
    }
  }
}

resource "aviatrix_distributed_firewalling_policy_list" "default" {
  policies {
    name     = "allow-internet"
    action   = "PERMIT"
    priority = 1001
    protocol = "TCP"
    logging  = true
    watch    = false
    port_ranges {
      lo = 443
    }
    src_smart_groups = [
      aviatrix_smart_group.rfc1918.uuid
    ]
    dst_smart_groups = [
      "def000ad-0000-0000-0000-000000000001" # Public Internet
    ]
    web_groups = [
      aviatrix_web_group.allow_internet_https.uuid
    ]
  }
  policies {
    name                     = "default-deny-all"
    action                   = "DENY"
    priority                 = 2147483646
    protocol                 = "Any"
    logging                  = true
    watch                    = false
    exclude_sg_orchestration = true
    src_smart_groups = [
      "def000ad-0000-0000-0000-000000000000" # Anywhere
    ]
    dst_smart_groups = [
      "def000ad-0000-0000-0000-000000000000" # Anywhere
    ]
  }
}

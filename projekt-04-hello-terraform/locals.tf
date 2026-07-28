locals {
  prefix = "tf-${var.environment}"
  nsg_rules = {
    ssh  = { priority = 1000, port = "22" }
    http = { priority = 1010, port = "80" }
  }
}


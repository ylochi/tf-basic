locals {
    environment = "dev1"
}

module "stack" {
    source = "../stack"
    environment = local.environment
}
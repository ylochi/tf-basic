locals {
    my_app = "yasmin-challenge-${var.environment}"
    current_region = data.aws_region.current.name
    current_account = data.aws_caller_identity.current.account_id
    tags = {
        terraform = true
    }
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
# KMS

module "kms" {
  source                  = "../module/kms"
  region                  = var.region
  alias_name              = var.alias_name
  description             = var.description
  common_tags             = var.common_tags
}

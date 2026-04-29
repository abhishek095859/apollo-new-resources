region = "eu-central-1"

common_tags = {
#  owner       = "rishabh.prasad@apollotyres.com"
  environment = "nonsapprod"
  map-migrated = "mig91CEGUP1GN"
  sourceCreation = "terraform"
#  project = "NAWC"
#  application = "NAWC Model Inferencing"
#  Criticality = "AA"
}


########################
#KMS Key
#########################
alias_name = "ATL-EUR-FRNK-NON-SAP-PROD-KMS-KEY"
description = "Encryption key for EBS volumes"

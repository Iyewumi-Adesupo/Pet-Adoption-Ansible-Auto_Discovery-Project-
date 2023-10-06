provider "aws" {
  region  = "eu-west-3"
  profile = "sue-ade"
}

provider "vault" {
  token   = "s.bT1oqrcYh8WIjC4JXriJRTAZ"
  address = "https://sophieplace.com"
}

data "vault_generic_secret" "db_secret" {
  path = "secret/database"
}
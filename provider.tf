provider "aws" {
  region  = "us-west-2"
  profile = "sue-ade"
}

provider "vault" {
  token   = "s.MLYtPIPJNKpxyBw3Ociy8ZW1"
  address = "https://crystalpalace.online"
}

data "vault_generic_secret" "db_secret" {
  path = "secret/database"
}
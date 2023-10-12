provider "aws" {
  region  = "us-west-2"
  profile = "sue-ade"
}

provider "vault" {
  token   = "s.ILohNPHqiEnNDfwLMvY5War1"
  address = "https://crystalpalace.online"
}

data "vault_generic_secret" "db_secret" {
  path = "secret/database"
}
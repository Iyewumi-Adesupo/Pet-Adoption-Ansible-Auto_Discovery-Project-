provider "aws" {
  region  = "eu-west-3"
  profile = "sue-ade"
}

provider "vault" {
  token   = "s.JFCrijF89UhcDaQtfWs3ifIV"
  address = "https://crystalpalace.online"
}

data "vault_generic_secret" "db_secret" {
  path = "secret/database"
}
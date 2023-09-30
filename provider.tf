provider "aws" {
  region  = "eu-west-3"
  profile = "sue-ade"
}

provider "vault" {
  token   = "s.Kth3OjIYvXnN9Xvx26ml7gPm"
  address = "https://crystalpalace.online"
}

data "vault_generic_secret" "db_secret" {
  path = "secret/database"
}
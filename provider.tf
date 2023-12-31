provider "aws" {
  region  = "us-west-2"
  profile = "sue-ade"
}

provider "vault" {
  token   = "s.IsTMwYwRYe68NQXhYhUkoBXt"
  address = "https://crystalpalace.online"
}

data "vault_generic_secret" "db_secret" {
  path = "secret/database"
}
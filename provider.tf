provider "aws" {
  region  = "eu-west-3"
  profile = "sue-ade"
}

provider "vault" {
  token   = "s.NaDxQxwYSjeFubuPHs4m9uG2"
  address = "https://crystalpalace.online"
}

data "vault_generic_secret" "db_secret" {
  path = "secret/database"
}
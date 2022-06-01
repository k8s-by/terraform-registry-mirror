terraform {
  required_version = ">= 0.13"

  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = ">= 3.6.0"
    }
    keycloak = {
      source  = "mrparkers/keycloak"
      version = ">= 3.8.1"
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}

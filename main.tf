# ==================================
# terraform設定
# ==================================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# ==================================
# provider設定
# ==================================
provider "aws" {
  profile = "kdl_hardening"
  region  = "ap-northeast-1"
}

# ==================================
# 変数
# ==================================
variable "project" {
  type = string
}
variable "user" {
  type = string
}

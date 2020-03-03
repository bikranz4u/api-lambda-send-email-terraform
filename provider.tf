provider "aws" {
  region                  = var.region
  shared_credentials_file = var.aws_credentials_file_path
  profile                 = var.aws_profile_name
  version                 = "~> 2.0"
}

terraform {
  backend "s3" {
    bucket         = "deanlist-tf-state-backend" 
    region         = "us-east-1"
    key            = "blog-tf-state/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "terraform-state-locking"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.30"
    }
  }
}

module "deanlist" {
  source = "../modules/static-blog"

  region = "us-east-1"
  bucket_name = "deanlist"
  domain_name = "deanlist.cc"
  
}
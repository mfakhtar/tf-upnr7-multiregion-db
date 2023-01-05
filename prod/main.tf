provider "aws" {
  region = "ap-south-1"
  alias  = "primary"
}

provider "aws" {
  region = "ap-southeast-1"
  alias  = "replica"
}

module "mysql_primary" {
  source = "../modules"
  providers = {
    aws = aws.replica
  }

  db_name     = "prod_db"
  db_username = var.db_username
  db_password = var.db_password

  # Must be enabled to support replication
  backup_retention_period = 1
}

module "mysql_replica" {
    source = "../modules"
    providers = {
    aws = aws.primary
  }
  # Make this a replica of the primary
  replicate_source_db = module.mysql_primary.arn
}
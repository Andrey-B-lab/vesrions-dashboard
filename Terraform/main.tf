data "aws_vpc" "default" {
  default = true
}

provider "aws" {        # provider definition
  region = "us-east-1"  # the region I run the EC2 instance
}

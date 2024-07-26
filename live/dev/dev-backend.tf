terraform {
  backend "s3" {
    bucket = "xsdkjshfksdfnl25347-terraform-state"
    region = "us-west-2"
    key    = "bloginstance-dev-state"
  }
}


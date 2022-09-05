terraform {
  backend "s3" {
    bucket = "vitfor-test-terraform-state"
    key    = "thanos/test.tfstate"
    region = "eu-west-2"
  }
}

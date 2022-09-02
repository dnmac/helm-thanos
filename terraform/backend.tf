terraform {
  backend "s3" {
    bucket = "vitfor-test-thanos-bucket"
    key    = "thanos/test.tfstate"
    region = "eu-west-2"
  }
}

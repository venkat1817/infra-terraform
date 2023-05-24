terraform {
  backend "s3" {
    bucket = "krishna1432"
    key    = "appdemo/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
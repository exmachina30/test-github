remote_state {
  backend = "s3"
  config = {
    bucket         = "timmy-prod-tfstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
  }
}

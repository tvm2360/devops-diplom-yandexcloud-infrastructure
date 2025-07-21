terraform {
  backend "s3" {
    region                   = "ru-central1"
    profile                  = "default"
    shared_credentials_files = ["backend_credentials.config"]
    bucket                   = "devops-diplom-bucket"
    key                      = "devops-diplom-yandexcloud/terraform.tfstate"
    endpoints = {
      s3       = "https://storage.yandexcloud.net"
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gj7h9s7j2d0b9mu40e/etnfac14qd9e1do9ph6k"
    }
    dynamodb_table = "devops-diplom-tfstate-lock-table"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

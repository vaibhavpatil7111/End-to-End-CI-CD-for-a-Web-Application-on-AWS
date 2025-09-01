terraform {
    backend "s3" {
        bucket = "my-terraform-state-bucket-211125508265"
        key = "cicd/terraform.tfstate"
        region = "us-east-1"
        encrypt = true
        use_lockfile = true
    }
}
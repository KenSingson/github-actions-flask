# Terraform Remote State DataSource - Remote Backend AWS S3
data "terraform_remote_state" "eks" {
    backend = "s3"
    config = {
        bucket = "s3-tfs-gb-st-01"
        key = "automation/dev/finance/eks/cluster/eksdemo-terraform.tfstate"
        region = "ap-southeast-1"
    }
}
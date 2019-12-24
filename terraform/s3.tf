resource "aws_s3_bucket" "site" {
  bucket = var.site
  acl = "public-read" # Needs to be public for a website

  versioning {
    enabled = false
  }

  lifecycle_rule {
    prefix = ""
    enabled = true
    noncurrent_version_expiration {
      days = 7
    }
  }

  website {
    index_document = "index.html"
    error_document = "404.html" # Actually displayed for all 4XX errors
  }

  logging {
    target_bucket = aws_s3_bucket.log-bucket.id
  }

  tags = {
    Application = "Blog"
    Owner = "Joe Green"
    Provisioner = "Terraform"
    ProvisionerSrc = var.github_url
  }
}

resource "aws_s3_bucket" "www-bucket" {
  bucket = "www.${var.site}"
  acl = "public-read" # Needs to be public for a website

  website {
    redirect_all_requests_to = var.site
  }

  tags = {
    Application = "Blog"
    Owner = "Joe Green"
    Provisioner = "Terraform"
    ProvisionerSrc = var.github_url
  }
}

resource "aws_s3_bucket" "log-bucket" {
  bucket = "logs.${var.site}"
  acl    = "log-delivery-write"

  lifecycle_rule {
    prefix = ""
    enabled = true
    expiration {
      days = 730
    }
  }
}
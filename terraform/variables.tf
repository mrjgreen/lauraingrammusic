variable "site" {
  type = string
  description = "The domain name for the site. Will create an S3 bucket with the same name."
}

variable "github_url" {
  type = string
  description = "The URL of the related github URL"
}

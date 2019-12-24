resource "aws_route53_zone" "site" {
  name = var.site
  comment = "Managed by Terraform at github.com/mrjgreen/lauraingrammusic"
  tags = {
    Application = "Blog"
    Owner = "Joe Green"
    Provisioner = "Terraform"
    ProvisionerSrc = var.github_url
  }
}

resource "aws_route53_record" "site" {
  zone_id = aws_route53_zone.site.zone_id
  name = var.site
  type = "A"

  alias {
    name = aws_s3_bucket.site.website_domain
    zone_id = aws_s3_bucket.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www-record" {
  zone_id = aws_route53_zone.site.zone_id
  name = "www.${var.site}"
  type = "A"

  alias {
    name = aws_s3_bucket.www-bucket.website_domain
    zone_id = aws_s3_bucket.www-bucket.hosted_zone_id
    evaluate_target_health = false
  }
}
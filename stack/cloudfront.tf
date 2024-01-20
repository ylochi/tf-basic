resource "aws_cloudfront_origin_access_identity" "cf_oai_env" {
  comment = "challenge oai"
}

data "aws_iam_policy_document" "allow_access_from_cloudfront"{
    statement {
        actions = [
            "s3:GetObject"
        ]
        resources = [
             "${aws_s3_bucket.my_s3.arn}/*",
        ]
         principals {
            type        = "AWS"
            identifiers = [aws_cloudfront_origin_access_identity.cf_oai_env.iam_arn]
        }
  }
}


resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.my_s3.id
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
}

resource "aws_cloudfront_cache_policy" "cf_cache_policy" {
  name        = "TTL-5to15"
  comment     = "cache"
  default_ttl = 10
  max_ttl     = 15
  min_ttl     = 5

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name  =  aws_s3_bucket.my_s3.bucket_regional_domain_name
    origin_id  = aws_s3_bucket.my_s3.bucket_regional_domain_name
    s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.cf_oai_env.cloudfront_access_identity_path
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "challenge"
  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.my_s3.bucket_regional_domain_name
    viewer_protocol_policy  = "redirect-to-https"

    cache_policy_id = aws_cloudfront_cache_policy.cf_cache_policy.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
    custom_error_response{
        error_code = "403"
        response_code = "200"
        response_page_path = "/index.html"
        error_caching_min_ttl = 60
    }
    viewer_certificate {
    cloudfront_default_certificate = true
  }
}
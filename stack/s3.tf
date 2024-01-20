resource "aws_s3_bucket" "my_s3" {
  bucket = "${local.my_app}-my-s3"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "my_s3_encryption_configuration" {
  bucket = aws_s3_bucket.my_s3.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}


resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my_s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



resource "random_string" "bucket_suffix" {
  length  = 26
  upper   = false
  special = false
}

resource "aws_s3_bucket" "website" {
  bucket = "cloud-resume-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "Cloud Resume"
    Environment = "Dev"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "only_allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    "Version" = "2012-10-17",
    "Id"      = "PolicyForCloudFront",
    "Statement" = [
      {
        "Sid"    = "1",
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "cloudfront.amazonaws.com"
        },
        "Action" = "s3:GetObject",
        "Resource" = [
          aws_s3_bucket.website.arn,
          "${aws_s3_bucket.website.arn}/*"
        ],
        "Condition" = {
          "StringEquals" = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
          }
        }
      }
    ]
  })
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website.id
  key    = "index.html"
  source = "./public_html/index.html"
  content_type = "text/html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("./public_html/index.html")
}

resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.website.id
  key    = "error.html"
  source = "./public_html/error.html"
  content_type = "text/html"
  etag   = filemd5("./public_html/error.html")
}

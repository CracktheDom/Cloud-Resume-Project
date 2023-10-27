# output "bucket_name" {
#   description = "Name of S3 bucket"
#   value       = aws_s3_bucket.website.id
# }

output "cloudfront_domain_name" {
  description = "URL of CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

# output s3_bucket_endpoint {
#   description = "The website endpoint"
#   value = aws_s3_bucket_website_configuration.website.website_endpoint
# }

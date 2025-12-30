output "upload_bucket_name" {
  description = "S3 upload bucket name"
  value       = aws_s3_bucket.uploads.id
}

output "upload_bucket_arn" {
  description = "S3 upload bucket ARN"
  value       = aws_s3_bucket.uploads.arn
}

output "upload_bucket_domain_name" {
  description = "S3 upload bucket domain name"
  value       = aws_s3_bucket.uploads.bucket_domain_name
}

output "upload_bucket_regional_domain_name" {
  description = "S3 upload bucket regional domain name"
  value       = aws_s3_bucket.uploads.bucket_regional_domain_name
}

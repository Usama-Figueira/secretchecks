provider "aws" {
  region = "us-east-1"
}

# Insecure IAM user with full admin access
resource "aws_iam_user" "insecure_user" {
  name = "insecure-user"
}

resource "aws_iam_user_policy_attachment" "admin_access" {
  user       = aws_iam_user.insecure_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Access keys for the user (no MFA)
resource "aws_iam_access_key" "insecure_user_key" {
  user = aws_iam_user.insecure_user.name
}

output "insecure_access_key" {
  value = aws_iam_access_key.insecure_user_key.id
}

output "insecure_secret_key" {
  value     = aws_iam_access_key.insecure_user_key.secret
  sensitive = true
}

# S3 bucket with public read/write access
resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "my-insecure-bucket-example-123456"
  acl    = "public-read-write"
  force_destroy = true
}

# No logging, no versioning, no encryption, no block public access
resource "aws_s3_bucket_public_access_block" "insecure_block" {
  bucket = aws_s3_bucket.insecure_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "web" {
  bucket = "tinavarela-githubactions-demo-cohorte3"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    Propiedad   = "tina"
  }
}

resource "aws_s3_bucket_website_configuration" "web_config" {
  bucket = aws_s3_bucket.web.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "web_public" {
  bucket = aws_s3_bucket.web.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket     = aws_s3_bucket.web.id
  depends_on = [aws_s3_bucket_public_access_block.web_public]

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "arn:aws:s3:::tinavarela-githubactions-demo-cohorte3/*"
    }]
  })
}

output "bucket_name" {
  value = aws_s3_bucket.web.bucket
}

output "website_url" {
  value = "http://${aws_s3_bucket.web.bucket}.s3-website-us-east-1.amazonaws.com"
}
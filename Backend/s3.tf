resource "aws_s3_bucket" "tf_bucket" {
  bucket        = "formation-dev"
  force_destroy = false

  tags = {
    Name        = "Formation bucket"
    Environment = "Dev"
  }
}
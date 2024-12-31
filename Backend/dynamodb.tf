resource "aws_dynamodb_table" "formation_table" {
  name         = "formation_lock_table"
  billing_mode = "PEY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Formation lock table"
    Environment = "Dev"
  }
}
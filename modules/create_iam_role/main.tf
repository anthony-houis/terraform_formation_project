resource "aws_iam_role" "aws_iam_eks_role" {
  name = var.role_name
  tags = {
    "Name" = var.Name
  }
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "${var.service}.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
output "role_name" {
  value = aws_iam_role.aws_iam_eks_role.name
}

output "role_arn" {
  value = aws_iam_role.aws_iam_eks_role.arn
}
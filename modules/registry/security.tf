
resource "aws_iam_role" "ecr_access_role" {
  name = "ECRAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecr_full_access" {
  name       = "ECRAccessPolicyAttachment"
  roles      = [aws_iam_role.ecr_access_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_policy" "ecr_specific_access" {
  name        = "ECRSpecificAccessPolicy"
  description = "Policy for ECR specific repository access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = [
          "arn:aws:ecr:us-east-1:123456789012:repository/django",
          "arn:aws:ecr:us-east-1:123456789012:repository/fastapi"
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecr_specific_access_attachment" {
  name       = "ECRSpecificAccessAttachment"
  roles      = [aws_iam_role.ecr_access_role.name]
  policy_arn = aws_iam_policy.ecr_specific_access.arn
}

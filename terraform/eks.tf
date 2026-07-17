resource "aws_eks_cluster" "eks_cluster" {

  name = var.cluster_name

  version = "1.30"

  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {

    subnet_ids = [

      aws_subnet.private_subnet_1.id,

      aws_subnet.private_subnet_2.id,

      aws_subnet.public_subnet_1.id,

      aws_subnet.public_subnet_2.id

    ]

    endpoint_private_access = true

    endpoint_public_access = true

  }

  depends_on = [

    aws_iam_role_policy_attachment.eks_cluster_policy

  ]

  tags = {

    Name = var.cluster_name

  }

}
resource "aws_eks_node_group" "worker_nodes" {

  cluster_name = aws_eks_cluster.eks_cluster.name

  node_group_name = "DevOps-NodeGroup"

  node_role_arn = aws_iam_role.eks_node_role.arn

  subnet_ids = [

    aws_subnet.private_subnet_1.id,

    aws_subnet.private_subnet_2.id

  ]

  instance_types = [

    var.instance_type

  ]

  capacity_type = "ON_DEMAND"

  scaling_config {

    desired_size = var.desired_size

    min_size = var.min_size

    max_size = var.max_size

  }

  update_config {

    max_unavailable = 1

  }

  depends_on = [

    aws_iam_role_policy_attachment.worker_node_policy,

    aws_iam_role_policy_attachment.cni_policy,

    aws_iam_role_policy_attachment.ecr_policy

  ]

  tags = {

    Name = "DevOps-WorkerNodes"

  }

}
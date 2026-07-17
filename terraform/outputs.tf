output "vpc_id" {

  value = aws_vpc.eks_vpc.id

}

output "cluster_name" {

  value = aws_eks_cluster.eks_cluster.name

}

output "cluster_endpoint" {

  value = aws_eks_cluster.eks_cluster.endpoint

}

output "cluster_version" {

  value = aws_eks_cluster.eks_cluster.version

}

output "nodegroup_name" {

  value = aws_eks_node_group.worker_nodes.node_group_name

}

output "region" {

  value = var.aws_region

}
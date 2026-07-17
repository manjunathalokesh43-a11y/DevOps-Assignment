#############################
# Get EKS Cluster Details
#############################

data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks_cluster.name
}

#############################
# IAM Policy Document
#############################

data "aws_iam_policy_document" "ebs_csi_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.eks.arn
      ]
    }

    condition {
      test = "StringEquals"

      variable = "${replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:kube-system:ebs-csi-controller-sa"
      ]
    }
  }
}

#############################
# IAM Role
#############################

resource "aws_iam_role" "ebs_csi_role" {

  name = "AmazonEKS_EBS_CSI_DriverRole"

  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role_policy.json
}

#############################
# Attach AWS Managed Policy
#############################

resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {

  role = aws_iam_role.ebs_csi_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"

}

#############################
# OIDC Provider
#############################

resource "aws_iam_openid_connect_provider" "eks" {

  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "9e99a48a9960b14926bb7f3b02e22da0ecd4e6d8"
  ]
}

#############################
# Install EBS CSI Addon
#############################

resource "aws_eks_addon" "ebs_csi" {

  cluster_name = aws_eks_cluster.eks_cluster.name

  addon_name = "aws-ebs-csi-driver"

  service_account_role_arn = aws_iam_role.ebs_csi_role.arn

  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi_policy
  ]
}
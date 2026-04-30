# 1. NEW: IAM Policy for Self-Tagging
# Nodes need this to "Edit" their own Name tag in the EC2 console
resource "aws_iam_role_policy" "node_tagging" {
  name = "EKSNodeSelfTaggingPolicy"
  role = aws_iam_role.nodes.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ec2:CreateTags", "ec2:DescribeInstances","autoscaling:DescribeAutoScalingGroups"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# 2. NEW: Launch Template
# This handles the instance configuration and the naming logic
resource "aws_launch_template" "eks_nodes" {
  name_prefix = "ATL-APAC-MUM-DEVOPS-PROD-NAWC-LT-"

    user_data = base64encode(<<-EOF
    MIME-Version: 1.0
    Content-Type: multipart/mixed; boundary="==BOUNDARY=="

    --==BOUNDARY==
    Content-Type: text/x-shellscript; charset="us-ascii"

    #!/bin/bash
    # 1. Install jq (Required for JSON parsing)
    dnf install -y jq

    # 2. Get Metadata Token & Details (IMDSv2)
    TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
    INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)
    REGION=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/region)

    # 3. Identify the Auto Scaling Group (ASG)
    ASG_NAME=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --region "$REGION" --query 'Reservations[0].Instances[0].Tags[?Key==`aws:autoscaling:groupName`].Value' --output text)

    # 4. Fetch running instances in this ASG, sorted by Launch Time
    # This ensures the oldest node is 01, second is 02, etc.
    ID_LIST=$(aws ec2 describe-instances \
      --filters "Name=tag:aws:autoscaling:groupName,Values=$ASG_NAME" "Name=instance-state-name,Values=running" \
      --region "$REGION" --output json \
      | jq -r '.Reservations[].Instances | sort_by(.LaunchTime) | .[].InstanceId')

    # 5. Find the position of THIS instance in that list
    INDEX=$(echo "$ID_LIST" | grep -n "$INSTANCE_ID" | cut -d: -f1)

    # 6. Apply the tag only if an index was found
    if [ -n "$INDEX" ]; then
      MY_NUM=$(printf "%02d" "$INDEX")
      PREFIX="ATL-APAC-MUM-DEVOPS-PROD-NAWC-EKS-WORKER-NODE"
      aws ec2 create-tags --resources "$INSTANCE_ID" --tags Key=Name,Value="$PREFIX-$MY_NUM" --region "$REGION"
    fi
    --==BOUNDARY==--
  EOF
  )

  # instance_type and monitoring moved here
  instance_type = var.instance_type

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ATL-APAC-MUM-DEVOPS-PROD-NAWC-EKS-WORKER-NODE-TEMP" # Temporary tag until script runs
    }
  }
}

# 3. EKS Cluster IAM Role (Unchanged)
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# 4. EKS Cluster (Unchanged)
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = "1.34"
  vpc_config { subnet_ids = var.subnet_ids }
  depends_on = [aws_iam_role_policy_attachment.cluster_policy]
}

# 5. Node Group IAM Role (Unchanged)
resource "aws_iam_role" "nodes" {
  name = "${var.cluster_name}-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "nodes_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ])
  policy_arn = each.value
  role       = aws_iam_role.nodes.name
}

# 6. UPDATED: Managed Node Group
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "ATL-APAC-MUM-DEVOPS-PROD-NAWC-EKS-WORKER-NODE-GROUP"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 3
    min_size     = var.min_size
    max_size     = var.max_size
  }

  # Use the Launch Template we created above
  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = aws_launch_template.eks_nodes.latest_version
  }

  ami_type      = "AL2023_ARM_64_STANDARD"
  capacity_type = "ON_DEMAND"

  labels = { role = "worker" }

  depends_on = [
    aws_iam_role_policy_attachment.nodes_policies,
    aws_iam_role_policy.node_tagging
  ]
}

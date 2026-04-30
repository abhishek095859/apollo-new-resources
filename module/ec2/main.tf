data "aws_ami" "windows_2019" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    # Updated filter for Windows Server 2019
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "this" {
  # Updated reference to the windows_2019 data source
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.windows_2019.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile != "" ? var.iam_instance_profile : null

  # Root EBS volume
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    kms_key_id            = var.kms_key_arn
    delete_on_termination = true
  }

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    http_endpoint               = "enabled"
  }

  tags = merge(var.common_tags, { Name = var.instance_name })

  volume_tags = merge(var.common_tags, { Name = "${var.instance_name}-root-vol" })
}

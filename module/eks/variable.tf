variable "cluster_name" { type = string }
variable "subnet_ids" { type = list(string) }
variable "instance_type" { type = string }
variable "min_size" { type = number }
variable "max_size" { type = number }

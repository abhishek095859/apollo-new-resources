variable "bucket_name" { type = string }
variable "versioning" { type = bool }
variable "force_destroy" { type = bool }
variable "block_public_acls" { type = bool }
variable "block_public_policy" { type = bool }
variable "ignore_public_acls" { type = bool }
variable "restrict_public_buckets" { type = bool }
variable "tags" { type = map(string) }
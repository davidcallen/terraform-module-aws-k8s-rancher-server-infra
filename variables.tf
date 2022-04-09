variable "aws_region" {
  type = string
  validation {
    condition     = length(var.aws_region) > 0
    error_message = "Error : the variable 'aws_region' must be non-empty."
  }
}
variable "environment" {
  description = "Environment information e.g. account IDs, public/private subnet cidrs"
  type = object({
    name                         = string # Environment Account IDs are used for giving permissions to those Accounts for resources such as AMIs
    account_id                   = string
    resource_name_prefix         = string # For some environments  (e.g. Core, Customer/production) want to protect against accidental deletion of resources
    resource_deletion_protection = bool
    default_tags                 = map(string)
  })
  default = {
    name                         = ""
    account_id                   = ""
    resource_name_prefix         = ""
    resource_deletion_protection = true
    default_tags                 = {}
  }
}
variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  default     = ""
  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "Error : the variable 'vpc_id' must be non-empty."
  }
}
variable "vpc_private_subnet_ids" {
  description = "The VPC private subnet IDs list"
  type        = list(string)
  default     = []
}
variable "vpc_private_subnet_cidrs" {
  description = "The VPC private subnet CIDRs list"
  type        = list(string)
  default     = []
}
variable "route53_public_hosted_zone_id" {
  description = "Route53 Public Hosted Zone ID (if in use)."
  default     = ""
  type        = string
}
variable "route53_private_hosted_zone_id" {
  description = "Route53 Private Hosted Zone ID (if in use)."
  default     = ""
  type        = string
}
variable "cluster_ingress_allowed_cidrs" {
  description = "The Cluster ingress allowed CIDRs list"
  type        = list(string)
  default     = []
}
variable "ec2_instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "t3a.medium"
}
variable "rancher_server_dns" {
  type        = string
  description = "DNS host name of the Rancher server"
  validation {
    condition     = length(var.rancher_server_dns) > 0
    error_message = "Error : the variable 'rancher_server_dns' must be non-empty."
  }
}
variable "cluster_ssh_key_name" {
  description = "The SSH Key name to be installed in each ECS VM."
  type        = string
  default     = ""
  validation {
    condition     = length(var.cluster_ssh_key_name) > 0
    error_message = "Error : the variable 'cluster_ssh_key_name' must be non-empty."
  }
}
variable "cluster_ssh_private_key_filename" {
  type = string
  description = "FilePathName of SSH Private Key to be used to connect to cluster."
  validation {
    condition     = length(var.cluster_ssh_private_key_filename) > 0
    error_message = "Error : the variable 'cluster_ssh_private_key_filename' must be non-empty."
  }
}
variable "global_default_tags" {
  description = "Global default tags"
  default     = {}
  type        = map(string)
}

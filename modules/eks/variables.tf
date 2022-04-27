variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "cluster_version" {
  type = string
  default = "1.21"
}

variable "name_prefix" {
  type = string
}

variable "vpc_id" {}
variable "subnets" {}
variable "aws_kms_key_arn" {}

variable "node_groups" {
  type = map(object({
    min_size              = number
    max_size              = number
    desired_size          = number
    instance_type        = string 
  }))
  description = "Managed node group information"
  default = {
    "system-pods" = {
      min_size     = 1
      max_size     = 2
      desired_size = 1
      instance_type = "t2.medium"
    }

    "cpu-application" = {
      min_size     = 1
      max_size     = 2
      desired_size = 1
      instance_type = "t2.medium"
    }

    "gpu-application" = {
      min_size     = 1
      max_size     = 2
      desired_size = 1
      instance_type = "t2.medium"
  }
 }
}
variable "tags" {
  type = map(string)
}

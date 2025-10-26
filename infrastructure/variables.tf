###############################################################################
# variables.tf — Global Variables
###############################################################################

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "ap-southeast-2"
}

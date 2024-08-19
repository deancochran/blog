variable "region" {
    description = "Default region for provider"
    type        = string
    default     = "us-east-1"
}

variable "bucket_name" {
    description = "prefix of s3 bucket for app data"
    type        = string
}

variable "domain_name" {
    description = "Domain for website"
    type        = string
}
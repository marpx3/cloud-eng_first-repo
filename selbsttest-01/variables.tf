variable "environment" {
  type        = string
  description = "dev, prod oder test"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "env must be dev, test or prod !"
  }
}

variable "location" {
  type        = string
  description = "deploy location"

}
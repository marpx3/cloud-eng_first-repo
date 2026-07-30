variable "environment" {
  type        = string
  description = "Name der Umgebung (dev, test, ...)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must dev, test oder prod sein!"
  }
}

variable "location" {
  type        = string
  description = "Region wo die ressource deployed wird (bsp. westeurope)"
  default     = "westeurope"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH Public Key fuer die VM"
  default     = ""
}
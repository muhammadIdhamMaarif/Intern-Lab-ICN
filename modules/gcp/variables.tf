variable "project" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "region" {
  type     = string
  default  = "asia-southeast2"
  nullable = false
}

variable "zone" {
  type    = list(string)
  default = []
  validation {
    condition     = alltrue([for z in var.zone : startswith(z, "${var.region}-")])
    error_message = "All zones must be within the selected region"
  }
}

variable "gce_machine_type" {
  type    = string
  default = "e2-micro"
}



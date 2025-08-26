variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "app_image" {
  description = "Docker image for journal app"
  type        = string
  default     = "droffilc1/journal-starter:latest"
}

variable "db_password" {
  description = "Postgres password"
  type        = string
  sensitive   = true
}

variable "my_ip" {
  description = "Your workstation public IP"
  type        = string
}

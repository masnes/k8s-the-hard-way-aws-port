variable "key_name" {
  type = string
  description = "The name of the authorized key pair to allow connections to the nodes with."
}

variable "cluster_cidr" {
  type = "string"
  description = "possible pod cidr range"
  default = "10.200.0.0/16"
}

variable "allowed_ips" {
  type        = list(string)
  description = "A list of one or more ip addresses (not cidr's) that you will be accessing from."
  default     = ["73.78.216.54"]
}

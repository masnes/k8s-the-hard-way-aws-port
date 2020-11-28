variable "allowed_ips" {
  type        = list(string)
  description = "A list of one or more ip addresses (not cidr's) that you will be accessing from."
  default     = ["73.78.216.54"]
}

variable "authorized_key_path" {
  type = string
  description = "The path to the public ssh key associated with your private key which you will use to connect to nodes in the cluster."
  default = "~/.ssh/id_rsa.pub"
}

module "key" {
  source = "./key"
  authorized_key_path = var.authorized_key_path
}

module "k8s" {
  source = "./k8s"

  allowed_ips = var.allowed_ips
  key_name = module.key.key_name
}

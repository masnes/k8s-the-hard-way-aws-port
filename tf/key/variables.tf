variable "authorized_key_path" {
  type = string
  description = "The path to the public ssh key associated with your private key which you will use to connect to nodes in the cluster."
  default = "~/.ssh/id_rsa.pub"
}

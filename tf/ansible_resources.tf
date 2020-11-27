resource "local_file" "kubernetes_public_address" {
  depends_on = [
    aws_eip.k8s_external
  ]
  filename = "${path.module}/../ansible/group_vars/all/kubernetes_public_address.yml"
  content = <<-EOT
# Autogenerated by Terraform
kubernetes_public_address: "${aws_eip.k8s_external.public_ip}"
EOT
}

}

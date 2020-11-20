data "template_file" "kubernetes_public_address" {
  template = "$(file(\"${path.module/templates/kubernetes_public_address.cfg}\"))"
  depends_on = [
    aws_eip.k8s_external
  ]
  vars {
    kubernetes_public_address = "${aws_eip.k8s_external.public_ip}"
  }
}

resource "null_resource" "kubernetes_public_address" {
  triggers {
    template_rendered = "${data.template_file.kubernetes_public_address.rendered}"
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.kubernetes_public_address.rendered}' > '${path.module}/../ansible/group_vars/all/kubernetes_public_address.yml'"
  }
}

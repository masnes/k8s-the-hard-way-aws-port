data "local_file" "provided_public_key" {
  filename = pathexpand(var.authorized_key_path)
}

resource "aws_key_pair" "k8s_user_provided_key" {
  key_name = "k8s_playground_provided_key"
  public_key = data.local_file.provided_public_key.content
}

resource "aws_instance" "worker" {
  count = 3

  ami = "ami-032ed93ef3b2a867c" # Ubuntu 20.04 amd64

  key_name = var.key_name

  instance_type = "t2.nano" # TODO: this will need to be beefed up but keep it cheap for now

  subnet_id = aws_subnet.k8s.id

  vpc_security_group_ids = [
    aws_security_group.k8s.id
  ]

  source_dest_check           = false # Equivalent to '--can-ip-forward' in gcloud
  private_ip                  = "10.240.0.2${count.index}"
  associate_public_ip_address = true

  root_block_device {
    volume_size = 200
  }

  tags = {
    name                    = "worker${count.index}"
    worker                  = "true"
    kubernetes-the-hard-way = "true"
    type                    = "worker"
    pod_cidr                = "10.200.${count.index}.0/24"
  }
}

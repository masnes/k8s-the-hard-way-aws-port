resource "aws_instance" "controller" {
  count = 3

  ami = "ami-032ed93ef3b2a867c" # Ubuntu 20.04 amd64

  instance_type = "t2.nano" # TODO: this will need to be beefed up but keep it cheap for now

  subnet_id = aws_subnet.k8s.id

  source_dest_check           = false # Equivalent to '--can-ip-forward' in gcloud
  private_ip                  = "10.240.0.1${count.index}"
  associate_public_ip_address = true

  root_block_device {
    volume_size = 200
  }

  tags = {
    name                    = "controller${count.index}"
    controller              = "true"
    kubernetes-the-hard-way = "true"
    type                    = "controller"
  }
}

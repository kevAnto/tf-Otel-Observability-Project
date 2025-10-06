data "aws_ami" "latest-ubuntu-image" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "otel-server" {
  ami                         = data.aws_ami.latest-ubuntu-image.id
  instance_type               = var.instance_type
  key_name                    = "devops"
  subnet_id                   = aws_subnet.app1-subnet-1.id
  vpc_security_group_ids      = [aws_default_security_group.default-sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  user_data                   = file("otel-server-script.sh")
  tags = {
    Name = "${var.env_prefix}-app-server"
  }
}

resource "aws_ebs_volume" "otel-server-volume" {
  availability_zone = var.avail_zone
  size              = 20
  type              = "gp3"
  encrypted         = true
  
  tags = {
    Name = "${var.env_prefix}-app-server-volume"
  }
}

resource "aws_volume_attachment" "otel-server-volume-attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.otel-server-volume.id
  instance_id = aws_instance.otel-server.id
}

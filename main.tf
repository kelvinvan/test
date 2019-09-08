provider "aws" {
  access_key = ""
  secret_key = ""
  profile    = "default"
  region     = "ap-southeast-2"
}

resource "aws_vpc" "vpc1" {
  cidr_block = "192.168.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "vpc1"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.vpc1.id}"

  tags = {
    Name = "gateway"
  }
}


resource "aws_subnet" "subnet1" {
  vpc_id     = "${aws_vpc.vpc1.id}"
  cidr_block = "192.168.0.0/24"
}

resource "aws_security_group" "http" {
  name        = "http"
  description = "Allow http inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "http"
  }
}

resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow http inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh"
  }
}


resource "aws_network_interface" "server1" {
  subnet_id   = "${aws_subnet.subnet1.id}"
  private_ips = ["192.168.0.20"]
}

resource "aws_instance" "server1" {
  ami           = "ami-0edcec072887c2caa"
  instance_type = "t2.micro"
  key_name      = "key1"
  network_interface {
    network_interface_id = "${aws_network_interface.server1.id}"
    device_index         = 0
  }
  tags = {
    Name = "server1"
  }
}

resource "aws_instance" "server2" {
  ami             = "ami-0edcec072887c2caa"
  instance_type   = "t2.micro"
  key_name        = "key1"
  security_groups = ["ssh","http"]
  tags = {
    Name = "server2"
  }

}

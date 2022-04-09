provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "omc_vpc" {
      cidr_bloc = "172.16.0.0/16"
      
      tags = {
        Name = "my-example"
        env =  "test-env"
      }
}



resource "aws_subnet" "omc_subnet1" {
  vpc_id.   = aws_vpc.omc_vpc.id
  c

resource "aws_subnet" "omc_subnet1" {
  vpc_id            = aws_vpc.omc_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_network_interface" "omc_network_interface" {
  subnet_id   = aws_subnet.omc_subnet1.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "foo" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.omc_network_interface.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}

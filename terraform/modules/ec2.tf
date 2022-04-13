provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "omc_vpc" {
      cidr_block = "172.16.0.0/16"
      
      tags = {
        Name = "my-example"
        env =  "test-env"
      }
}


resource "aws_subnet" "omc_subnet" {
  vpc_id = aws_vpc.omc_vpc.id
  cidr_block = "172.16.10.0/24"
  availability_zone = "us-east-1a"
  
  tags = {
    name = "mysubnet"
    env = "dev environemnt"
  
  }
}

resource "aws_network_interface" "omc_network_interface" {
    subnet_id = aws_subnet.omc_subnet.id
    private_ips = ["172.16.10.100"]
    
    tags = {
    name = "my Network Interface"
    }
    
  }
   
resource "aws_instance" "my_tf_ec2_instance" {
  ami           = "ami-0b0ea68c435eb488d" # us-west-2
  instance_type = var.list[1]
  
  provisioner "remote-exec  {
     inline = [
      "sudo amazon-linux-extras install -y nginx1.12"
      "sudo systemctl start nginx"
     
     ]
  }
  
  
  module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  key_name   = "deployer-two"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}
  
  
  network_interface {
    network_interface_id = aws_network_interface.omc_network_interface.id
    device_index         = 0
  }
  credit_specification {
    cpu_credits = "unlimited"
  }
}

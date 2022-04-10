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


resource "aws_subnet" "omc_subnet" {
  vpc_id = aws_vpc.omc_vpc.id
  cide_bloc = "172.16.10.0/24"
  availabuilty_zone = "us-east-2a"
  
  tags = {
    name = "mysubnet"
    env = "dev environemnt"
  
  }
}

resource "aws_network_interface "omc_network_interface" {
    subnet_id = aws_subnet.omc_subnet.id
    private_ips = ["172.16.10.100"]
    
    tages = {
    name = "my Network Interface"
    }
    
   }
   
resource "aws_instance" "my_tf_ec2_instance" {
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

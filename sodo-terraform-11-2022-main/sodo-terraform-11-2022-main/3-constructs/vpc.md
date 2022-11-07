# VPC Lab.

Try to verify with `terraform validate` and `terraform apply` on every step of this exercise.

1. Create a project and set up AWS provider.
1. Create a VPC:

    ```tf
    resource "aws_vpc" "vpc" {

      cidr_block           = "10.0.0.0/8"
      enable_dns_hostnames = "true"
      enable_dns_support   = "true"
    
      tags = {
        "Name"       = "my-name-vpc"
        "Management" = "Terraform" 
      }
    }
    ```

1. Create an IGW:

    ```tf
    resource "aws_internet_gateway" "igw" {
      vpc_id = aws_vpc.vpc.id

      tags = {
        "Name"       = "my-name-igw"
        "Management" = "Terraform" 
      }
    }

1. Create a subnet:

    ```tf
    resource "aws_subnet" "public_subnet_a" {
      vpc_id                  = aws_vpc.vpc.id
      map_public_ip_on_launch = "true"
      availability_zone       = "eu-central-1a"
      cidr_block              = "10.0.0.0/16"
      
      tags = {
        "Name" = "my-name-public-1a"
        "Management" = "Terraform"
      }
    }
    ```

1. Create a route table for the subnet and a route to the Internet:

    ```tf
    resource "aws_route_table" "public" {
      vpc_id                  = aws_vpc.vpc.id

      tags = {
        "Name" = "my-name-public-rt"
        "Management" = "Terraform"
      }
    }

    resource "aws_route_table_association" "public" {
      subnet_id      = aws_subnet.public_subnet_a.id
      route_table_id = aws_route_table.public.id
    }

    resource "aws_route" "internet" {
      route_table_id         = aws_route_table.public.id
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = aws_internet_gateway.igw.id
    }
    ```

1. Add a second subnet in eu-central-1b on your own. 
1. How to set up a routing table for this second subnet?

## Challenge

1. Variablize the project:
    1. Set up "environment" variable as a prefix on every name of every created resource.
    1. Set up random suffix to be added to every name of created resources.
    1. Set up "vpc_cidr", "subnet_a_cidr" and "subnet_b_cidr" variables so that they can be changed for different environments.
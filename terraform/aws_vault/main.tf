data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_subnet_name]
  }
}

# Get id from my packer created Immutable Ubuntu AMI
data "aws_ami" "ubuntu" {
  owners      = ["self"]
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_instance_name]
  }
}

resource "aws_instance" "vault" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.selected.id
  security_groups = [
    aws_security_group.ingress-ssh.id,
    aws_security_group.vpc-vault.id
  ]
  key_name = var.instance_key_name
  tags = {
    Name = var.new_instance_name
  }

}

resource "tls_private_key" "generated" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "${var.instance_key_name}.pem"
}

resource "aws_key_pair" "generated" {
  key_name   = var.instance_key_name
  public_key = tls_private_key.generated.public_key_openssh

  lifecycle {
    ignore_changes = [key_name]
  }
}

resource "aws_security_group" "ingress-ssh" {
  name   = "allow-ssh"
  vpc_id = data.aws_vpc.selected.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vpc-vault" {
  name        = "vpc-vault"
  vpc_id      = data.aws_vpc.selected.id
  description = "Web Traffic"
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Vault API traffic
  ingress {
    description = "Allow Port 8200"
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Vault cluster traffic
  ingress {
    description = "Allow Port 8201"
    from_port   = 8201
    to_port     = 8201
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Internal Traffic
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_dynamodb_table" "dynamodb-table" {
  name           = var.dynamoTable
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "Path"
  range_key      = "Key"

  attribute {
    name = "Path"
    type = "S"
  }

  attribute {
    name = "Key"
    type = "S"
  }

  tags = {
    Name        = "vault-dynamodb-table"
    Environment = "prod"
  }
}

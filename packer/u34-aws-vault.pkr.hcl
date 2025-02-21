packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
  required_plugins {
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}


source "amazon-ebs" "ubuntu" {
  ami_name      = "u34-vault-ami"
  instance_type = "t2.micro"
  region        = "eu-central-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  vpc_filter  {
    filters = {
      "tag:Name": "k8s-vpc"
    }
  }

  ssh_username = "ubuntu"
  temporary_key_pair_type = "ed25519"
  associate_public_ip_address = true
}

build {
  name = "u34_vault"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "ansible" {
    playbook_file = "u34-vault.yml"
#    extra_arguments = [ "-vvvv" ] # or less vvv
  }

}

#####################################################
### Define Cloud provider
### @see https://www.terraform.io/docs/providers/aws/
#####################################################

provider "aws" {
  region = "" # Pick your Region @see http://docs.aws.amazon.com/general/latest/gr/rande.html
  access_key = "" # Enter your IAM Access Key here
  secret_key = "" # Enter your IAM Access Secret here
}

####################################################################
### Add SSH Keys to be able to access EC2 Instances
### @see https://www.terraform.io/docs/providers/aws/r/key_pair.html
####################################################################

resource "aws_key_pair" "publicaccesskey" {
  key_name = "admins-public-ssh-key"
  public_key = "ssh-rsa YOUR_PUBLIC_SSH_KEY_HERE an-email-address@i-dont-care.com"
}

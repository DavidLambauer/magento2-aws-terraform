##############################################################################################
### Security Groups
### see https://www.terraform.io/docs/providers/aws/r/security_group.html
##############################################################################################

resource "aws_security_group" "magento" {
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${aws_security_group.elb.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "rds" {
  name = "terraform-magento-rds"

  # Access granted for Port 3306 from Magento
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = ["${aws_security_group.magento.id}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "elb" {
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  # Can get everything on Port 80. Once we have a certificate, we can switch to 443
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "magento-redis" {
  ingress {
    from_port = 6379
    protocol = "TCP"
    to_port = 6379
    security_groups = [
      "${aws_security_group.magento.id}"
    ]
  }
  lifecycle {
    create_before_destroy = true
  }
}
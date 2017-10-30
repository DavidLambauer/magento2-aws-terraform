##############################################################################################
### Elastic Load Balancer
### @see https://www.terraform.io/docs/providers/aws/r/elb.html
##############################################################################################
resource "aws_elb" "magento" {
  name = "powershot"

  security_groups = [
    "${aws_security_group.elb.id}"
  ]

  availability_zones = [
    "${data.aws_availability_zones.all.names}" # ALL --> Multi AZ!
  ]

  health_check { # If you feel comfortable, you can change the TCP healtcheck to a http one. This will be an improvement
    healthy_threshold = 2
    unhealthy_threshold = 10
    timeout = 5
    interval = 30
    target = "TCP:80"
  }

  listener { # Currently we stick with HTTP. I'll add full SSL later
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
    instance_protocol = "http"
  }
}

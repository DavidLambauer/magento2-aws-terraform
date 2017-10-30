##############################################################################################
### Output
### @see https://www.terraform.io/intro/getting-started/outputs.html
##############################################################################################

output "elb_dns_name" { # DNS Endpoint for the Loadbalancer
  value = "${aws_elb.magento.dns_name}"
}
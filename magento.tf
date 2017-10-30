##############################################################################################
### Define Launch Configuration for the EC2 Instances.
### This Section defines what kind of EC2 Instances should be started in case the Autoscaling
### rules will grab and schedule new instances.
##############################################################################################

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
    ]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  owners = [
    "099720109477"
  ]
  # Canonical
}

resource "aws_launch_configuration" "magento" {
  enable_monitoring = true
  image_id = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.small"
  key_name = "${aws_key_pair.publicaccesskey.id}"
  user_data = "${data.template_file.installation_template.rendered}"

  security_groups = [
    "${aws_security_group.magento.id}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "installation_template" {
  template = "${file("install_application.tpl")}"

  vars {
    MAGE_MODE = "developer"

    MAGENTO_HOST_NAME = "${aws_elb.magento.dns_name}"
    MAGENTO_BASE_URL = "http://${aws_elb.magento.dns_name}/"

    MAGENTO_DATABASE_HOST = "${aws_rds_cluster.cluster_magento.endpoint}"
    MAGENTO_DATABASE_PORT = "${aws_rds_cluster.cluster_magento.port}"
    MAGENTO_DATABASE_NAME = "${aws_rds_cluster.cluster_magento.database_name}"
    MAGENTO_DATABASE_USER = "${aws_rds_cluster.cluster_magento.master_username}"
    MAGENTO_DATABASE_PASSWORD = "${aws_rds_cluster.cluster_magento.master_password}"

    MAGENTO_ADMIN_FRONTNAME = "${var.magento_admin_frontname}"

    MAGENTO_ADMIN_USER = "${var.magento_admin_user}"
    MAGENTO_ADMIN_PASSWORD = "${var.magento_admin_password}"
    MAGENTO_ADMIN_EMAIL = "${var.magento_admin_email}"
    MAGENTO_ADMIN_FIRSTNAME = "${var.magento_admin_firstname}"
    MAGENTO_ADMIN_LASTNAME = "${var.magento_admin_lastname}"

    MAGENTO_ADMIN_TIMEZONE = "${var.magento_admin_timezone }"
    MAGENTO_LOCALE = "${var.magento_locale}"

    GIT_REPOSITORY_URL = "${var.git-repository-url}"

    MAGENTO_REDIS_HOST_NAME = "${aws_elasticache_cluster.magento.cache_nodes.0.address}"
    MAGENTO_REDIS_PORT = "${aws_elasticache_cluster.magento.port}"
  }
}

#############################################################################
### Autoscaling Group
### @see https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html
#############################################################################

resource "aws_autoscaling_group" "magento" {
  launch_configuration = "${aws_launch_configuration.magento.id}"
  min_size = 2 # Minimum amount of EC2 Instances in an Autoscalingroup
  max_size = 5 # Maximum amount of EC2 Instances in an Autoscalingroup

  health_check_grace_period = 500 # Seconds to wait before checking the Health the first time.

  lifecycle {
    create_before_destroy = true
  }

  availability_zones = [
    "${data.aws_availability_zones.all.names}" # All --> Multi AZ
  ]

  load_balancers = [
    "${aws_elb.magento.name}"
  ]

  tag {
    key = "Magento 2"
    value = "terraform-asg-magento"
    propagate_at_launch = true
  }
}
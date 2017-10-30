################################################################################
### RDS CLUSTER Instance
### @see https://www.terraform.io/docs/providers/aws/r/rds_cluster_instance.html
################################################################################

resource "aws_rds_cluster_instance" "cluster_magento" {
  count = 1 # The amount of instances of your cluster
  apply_immediately = false
  identifier = "aurora-cluster-magento-${count.index}"
  cluster_identifier = "${aws_rds_cluster.cluster_magento.id}"
  instance_class = "db.t2.small" # @see https://aws.amazon.com/de/rds/instance-types/
  auto_minor_version_upgrade = true
  publicly_accessible = false
}

########################################################################
### RDS CLUSTER
### @see https://www.terraform.io/docs/providers/aws/r/rds_cluster.html
########################################################################

resource "aws_rds_cluster" "cluster_magento" {
  skip_final_snapshot = false
  final_snapshot_identifier = "magento-final-snap"
  cluster_identifier = "aurora-cluster-magento"
  database_name = "d${replace(lower(random_id.rds_database.b64), "-", "")}"
  master_username = "u${replace(lower(random_id.rds_username.b64), "-", "")}"
  master_password = "p${replace(lower(random_id.rds_password.b64), "-", "")}"
  backup_retention_period = 14 # Days of how long a backup will be saved
  preferred_backup_window = "00:00-02:00"
  preferred_maintenance_window = "Mon:02:00-Mon:04:00"
  port = 3306
  apply_immediately = false

  availability_zones = [
    "${data.aws_availability_zones.all.names}" # ALL --> Multi AZ
  ]

  vpc_security_group_ids = [
    "${aws_security_group.rds.id}"
  ]
}

resource "random_id" "rds_username" { # random generated database username
  byte_length = 8
}

resource "random_id" "rds_database" { # random generated database name
  byte_length = 8
}

resource "random_id" "rds_password" { # random generated database password
  byte_length = 16
}
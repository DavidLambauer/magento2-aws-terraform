##############################################################################################
### Elasticache Cluster
### see https://www.terraform.io/docs/providers/aws/r/elasticache_cluster.html
##############################################################################################

resource "aws_elasticache_cluster" "magento" {
  cluster_id = "magento"
  engine = "redis"
  maintenance_window = "sun:01:00-sun:03:00"
  engine_version = "2.8.24"
  node_type = "cache.t2.micro" # see https://aws.amazon.com/de/elasticache/pricing/
  num_cache_nodes = 1 # Amount of Redis Instances you would like to have
  port = 6379

  security_group_ids = [
    "${aws_security_group.magento-redis.id}"
  ]
}
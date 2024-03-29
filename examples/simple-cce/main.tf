resource "random_password" "this" {
  count = var.node_password == null ? 1 : 0

  length           = 16
  special          = true
  min_numeric      = 1
  min_special      = 1
  min_lower        = 1
  min_upper        = 1
  override_special = "!#"
}

module "vpc_service" {
  source = "github.com/terraform-huaweicloud-modules/terraform-huaweicloud-vpc"

  vpc_name              = var.vpc_name
  vpc_cidr_block        = var.vpc_cidr_block
  subnets_configuration = var.subnets_configuration

  is_security_group_create = false
}

module "cce_service" {
  source = "../.."

  # Cluster configuration
  cluster_flavor         = var.cluster_flavor
  container_network_type = var.container_network_type
  service_network_cidr   = var.service_network_cidr
  cluster_name           = var.cluster_name
  cluster_tags           = var.cluster_tags

  # Public configuration
  vpc_id             = module.vpc_service.vpc_id
  subnet_id          = try(module.vpc_service.subnet_ids[0], "")
  availability_zones = var.availability_zones

  # Node configuration
  nodes_configuration = var.nodes_configuration

  node_pools_configuration = var.node_pools_configuration
}

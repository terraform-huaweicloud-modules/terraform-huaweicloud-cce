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
  az_count               = var.az_count
  cluster_tags           = var.cluster_tags

  # Public configuration
  vpc_id             = module.vpc_service.vpc_id
  subnet_id          = try(module.vpc_service.subnet_ids[0], "")
  availability_zones = var.availability_zones

  # Node configuration
  node_name                       = var.node_name
  node_flavor                     = var.node_flavor
  node_password                   = var.node_password != null ? var.node_password : try(random_password.this[0].result, "")
  node_data_volumes_configuration = var.node_data_volumes_configuration
  node_tags                       = var.node_tags

  node_pool_name                       = var.node_pool_name
  node_pool_initial_ndoe_count         = var.node_pool_initial_ndoe_count
  node_pool_os_type                    = var.node_pool_os_type
  node_pool_flavor                     = var.node_pool_flavor
  node_pool_password                   = var.node_pool_password != null ? var.node_pool_password : try(random_password.this[0].result, "")
  node_pool_data_volumes_configuration = var.node_pool_data_volumes_configuration
  node_pool_tags                       = var.node_pool_tags
}

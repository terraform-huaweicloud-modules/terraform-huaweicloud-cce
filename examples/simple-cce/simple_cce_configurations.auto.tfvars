vpc_name = "simple_cce_vpc_via_modules"

vpc_cidr_block = "192.168.0.0/20"

subnets_configuration = [
  {
    name = "simple_cce_vpc_subnet_via_modules"
    cidr = "192.168.0.0/24"
  }
]

cluster_flavor = "cce.s2.small"

container_network_type = "overlay_l2"

service_network_cidr = "10.248.0.0/16"

cluster_name = "simple-cce-cluster-via-modules"

cluster_tags = {
  Creator = "terraform-huaweicloud-cce"
}

nodes_configuration = [
  {
    name               = "simple-cce-node-pool-via-modules"
    flavor_id          = "s6.large.2"
    os                 = "EulerOS 2.9"
    initial_node_count = 1
    password           = "Test@123"
  }
]

node_pools_configuration = [
  {
    name               = "simple-cce-node-pool-via-modules"
    flavor_id          = "s6.large.2"
    os                 = "EulerOS 2.9"
    initial_node_count = 1
    password           = "Test@123"
  }
]

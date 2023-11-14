data "huaweicloud_availability_zones" "this" {
  count = length(var.availability_zones) < 1 ? 1 : 0
}

data "huaweicloud_compute_flavors" "this" {
  availability_zone = length(var.availability_zones) > 0 ? var.availability_zones[0] : data.huaweicloud_availability_zones.this[0].names[0]
  performance_type  = "normal"
  cpu_core_count    = 2
  memory_size       = 4
}

resource "huaweicloud_vpc_eip" "this" {
  count = var.cluster_public_access && var.cluster_eip_address == null ? 1 : 0
  publicip {
    type = var.cluster_eip_type
  }
  bandwidth {
    name        = var.cluster_eip_bandwidth_name != null ? var.cluster_eip_bandwidth_name : var.cluster_name
    size        = var.cluster_eip_bandwidth_size
    share_type  = var.cluster_eip_bandwidth_share_type
    charge_mode = var.cluster_eip_bandwidth_charge_mode
  }

  charging_mode = var.charging_mode
  period_unit   = var.period_unit
  period        = var.period
  auto_renew    = var.is_auto_renew
}

resource "huaweicloud_cce_cluster" "this" {
  count = var.is_cluster_create ? 1 : 0

  cluster_type    = var.cluster_type
  cluster_version = var.cluster_version
  flavor_id       = var.cluster_flavor

  vpc_id                 = var.vpc_id
  subnet_id              = var.subnet_id
  container_network_type = var.container_network_type
  container_network_cidr = var.container_network_cidr
  service_network_cidr   = var.service_network_cidr
  eip                    = var.cluster_public_access ? (var.cluster_eip_address != null ? var.cluster_eip_address : huaweicloud_vpc_eip.this[0].address) : null

  // Turbo configuration
  eni_subnet_id   = var.eni_subnet_id
  eni_subnet_cidr = var.eni_subnet_cidr

  name                  = var.name_suffix != "" ? format("%s-%s", var.cluster_name, var.name_suffix) : var.cluster_name
  description           = var.cluster_description
  enterprise_project_id = var.enterprise_project_id

  authentication_mode              = var.authentication_mode
  authenticating_proxy_ca          = var.authenticating_proxy_ca
  authenticating_proxy_cert        = var.authenticating_proxy_cert
  authenticating_proxy_private_key = var.authenticating_proxy_private_key
  kube_proxy_mode                  = var.kube_proxy_mode
  extend_param                     = var.cluster_extend_params

  dynamic "masters" {
    for_each = length(var.cluster_multi_availability_zones) > 0 ? var.cluster_multi_availability_zones : length(var.availability_zones) > 0 ? slice(var.availability_zones, 0, var.az_count) : slice(data.huaweicloud_availability_zones.this[0].names, 0, var.az_count)

    content {
      availability_zone = masters.value
    }
  }

  tags = merge(
    { "Name" = var.name_suffix != "" ? format("%s-%s", var.node_name, var.name_suffix) : var.node_name },
  var.cluster_tags)

  charging_mode = var.charging_mode
  period_unit   = var.period_unit
  period        = var.period
  auto_renew    = var.is_auto_renew

  // Whether delete the related resources when container is terminal
  delete_evs = var.is_delete_evs
  delete_obs = var.is_delete_obs
  delete_sfs = var.is_delete_sfs
  delete_efs = var.is_delete_efs
  delete_all = var.is_delete_all
}

resource "huaweicloud_cce_node" "this" {
  count = var.is_cluster_create && var.is_node_create ? 1 : 0

  cluster_id   = huaweicloud_cce_cluster.this[0].id
  name         = var.name_suffix != "" ? format("%s-%s", var.node_name, var.name_suffix) : var.node_name
  flavor_id    = var.node_flavor
  os           = var.os_type
  runtime      = var.runtime
  extend_param = var.node_extend_params

  availability_zone = length(var.availability_zones) > 0 ? var.availability_zones[0] : data.huaweicloud_availability_zones.this[0].names[0]
  subnet_id         = var.subnet_id
  fixed_ip          = var.subnet_fixed_ip
  ecs_group_id      = var.ecs_group_id
  max_pods          = var.max_pods_number

  iptype                = var.eip_type
  eip_id                = var.eip_id
  bandwidth_charge_mode = var.bandwidth_charge_mode
  bandwidth_size        = var.bandwidth_size
  sharetype             = var.bandwidth_share_type

  dynamic "taints" {
    for_each = var.node_taint_configuration

    content {
      key    = taints.value["key"]
      value  = taints.value["value"]
      effect = taints.value["effect"]
    }
  }

  key_pair = var.keypair_name
  password = var.node_password

  preinstall  = var.pre_install_script
  postinstall = var.post_install_script

  root_volume {
    volumetype    = var.node_root_volume_configuration["type"]
    size          = var.node_root_volume_configuration["size"]
    extend_params = var.node_root_volume_configuration["extend_params"]
  }

  dynamic "data_volumes" {
    for_each = var.node_data_volumes_configuration

    content {
      volumetype    = data_volumes.value["type"]
      size          = data_volumes.value["size"]
      extend_params = data_volumes.value["extend_params"]
      kms_key_id    = data_volumes.value["kms_key_id"]
    }
  }

  dynamic "storage" {
    for_each = var.node_storage_configuration != null ? [var.node_storage_configuration] : []

    content {
      dynamic "selectors" {
        for_each = var.node_storage_configuration["selectors"]

        content {
          name                           = selectors.value["name"]
          type                           = selectors.value["type"]
          match_label_size               = selectors.value["match_label_size"]
          match_label_volume_type        = selectors.value["match_label_volume_type"]
          match_label_metadata_encrypted = selectors.value["match_label_metadata_encrypted"]
          match_label_metadata_cmkid     = selectors.value["match_label_metadata_cmkid"]
          match_label_count              = selectors.value["match_label_count"]
        }
      }

      dynamic "groups" {
        for_each = var.node_storage_configuration["groups"]
        content {
          name           = groups.value["name"]
          selector_names = groups.value["selector_names"]
          cce_managed    = groups.value["cce_managed"]

          dynamic "virtual_spaces" {
            for_each = groups.value["virtual_spaces"]

            content {
              name            = virtual_spaces.value["name"]
              size            = virtual_spaces.value["size"]
              lvm_lv_type     = virtual_spaces.value["lvm_lv_type"]
              lvm_path        = virtual_spaces.value["lvm_path"]
              runtime_lv_type = virtual_spaces.value["runtime_lv_type"]
            }
          }
        }
      }
    }
  }

  # Billing mode
  charging_mode = var.charging_mode
  period_unit   = var.period_unit
  period        = var.period
  auto_renew    = var.is_auto_renew

  labels = var.node_k8s_labels
  tags = merge(
    { "Name" = var.name_suffix != "" ? format("%s-%s", var.node_name, var.name_suffix) : var.node_name },
  var.node_tags)
}


resource "huaweicloud_cce_node_pool" "this" {
  count = length(var.node_pools_configuration)

  cluster_id               = huaweicloud_cce_cluster.this[0].id
  name                     = var.name_suffix != "" ? format("%s-%s", lookup(element(var.node_pools_configuration, count.index), "name"), var.name_suffix) : lookup(element(var.node_pools_configuration, count.index), "name")
  initial_node_count       = lookup(element(var.node_pools_configuration, count.index), "initial_node_count")
  flavor_id                = lookup(element(var.node_pools_configuration, count.index), "flavor_id") != null ? lookup(element(var.node_pools_configuration, count.index), "flavor_id") : data.huaweicloud_compute_flavors.this.ids[0]
  type                     = lookup(element(var.node_pools_configuration, count.index), "type")
  availability_zone        = length(var.availability_zones) > 0 ? var.availability_zones[0] : data.huaweicloud_availability_zones.this[0].names[0]
  os                       = lookup(element(var.node_pools_configuration, count.index), "os")
  key_pair                 = lookup(element(var.node_pools_configuration, count.index), "key_pair")
  password                 = lookup(element(var.node_pools_configuration, count.index), "password")
  subnet_id                = var.subnet_id
  ecs_group_id             = lookup(element(var.node_pools_configuration, count.index), "ecs_group_id")
  scall_enable             = lookup(element(var.node_pools_configuration, count.index), "scale_enable")
  min_node_count           = lookup(element(var.node_pools_configuration, count.index), "min_node_count")
  max_node_count           = lookup(element(var.node_pools_configuration, count.index), "max_node_count")
  scale_down_cooldown_time = lookup(element(var.node_pools_configuration, count.index), "scale_down_cooldown_time")
  priority                 = lookup(element(var.node_pools_configuration, count.index), "priority")
  security_groups          = lookup(element(var.node_pools_configuration, count.index), "security_groups")
  pod_security_groups      = lookup(element(var.node_pools_configuration, count.index), "pod_security_groups")
  initialized_conditions   = lookup(element(var.node_pools_configuration, count.index), "initialized_conditions")
  labels                   = lookup(element(var.node_pools_configuration, count.index), "labels")
  runtime                  = lookup(element(var.node_pools_configuration, count.index), "runtime")
  tags                     = lookup(element(var.node_pools_configuration, count.index), "tags")

  dynamic "extend_params" {
    for_each = lookup(element(var.node_pools_configuration, count.index), "extend_params") != null ? [lookup(element(var.node_pools_configuration, count.index), "extend_params")] : []

    content {
      max_pods            = extend_params.value["max_pods"]
      docker_base_size    = extend_params.value["docker_base_size"]
      preinstall          = extend_params.value["preinstall"]
      postinstall         = extend_params.value["postinstall"]
      node_image_id       = extend_params.value["node_image_id"]
      node_multi_queue    = extend_params.value["node_multi_queue"]
      nic_threshold       = extend_params.value["nic_threshold"]
      agency_name         = extend_params.value["agency_name"]
      kube_reserved_mem   = extend_params.value["kube_reserved_mem"]
      system_reserved_mem = extend_params.value["system_reserved_mem"]
    }
  }

  dynamic "taints" {
    for_each = lookup(element(var.node_pools_configuration, count.index), "taints")

    content {
      key    = taints.value["key"]
      value  = taints.value["value"]
      effect = taints.value["effect"]
    }
  }

  root_volume {
    volumetype    = lookup(element(var.node_pools_configuration, count.index), "root_volume")["type"]
    size          = lookup(element(var.node_pools_configuration, count.index), "root_volume")["size"]
    extend_params = lookup(element(var.node_pools_configuration, count.index), "root_volume")["extend_params"]
    kms_key_id    = lookup(element(var.node_pools_configuration, count.index), "root_volume")["kms_key_id"]
    dss_pool_id   = lookup(element(var.node_pools_configuration, count.index), "root_volume")["dss_pool_id"]
  }

  dynamic "data_volumes" {
    for_each = lookup(element(var.node_pools_configuration, count.index), "data_volumes")

    content {
      volumetype    = data_volumes.value["type"]
      size          = data_volumes.value["size"]
      extend_params = data_volumes.value["extend_params"]
      kms_key_id    = data_volumes.value["kms_key_id"]
      dss_pool_id   = data_volumes.value["dss_pool_id"]
    }
  }

  dynamic "storage" {
    for_each = lookup(element(var.node_pools_configuration, count.index), "storage") != null ? [lookup(element(var.node_pools_configuration, count.index), "storage")] : []

    content {
      dynamic "selectors" {
        for_each = lookup(element(var.node_pools_configuration, count.index), "storage")["selectors"]

        content {
          name                           = selectors.value["name"]
          type                           = selectors.value["type"]
          match_label_size               = selectors.value["match_label_size"]
          match_label_volume_type        = selectors.value["match_label_volume_type"]
          match_label_metadata_encrypted = selectors.value["match_label_metadata_encrypted"]
          match_label_metadata_cmkid     = selectors.value["match_label_metadata_cmkid"]
          match_label_count              = selectors.value["match_label_count"]
        }
      }

      dynamic "groups" {
        for_each = lookup(element(var.node_pools_configuration, count.index), "storage")["groups"]
        content {
          name           = groups.value["name"]
          selector_names = groups.value["selector_names"]
          cce_managed    = groups.value["cce_managed"]

          dynamic "virtual_spaces" {
            for_each = groups.value["virtual_spaces"]

            content {
              name            = virtual_spaces.value["name"]
              size            = virtual_spaces.value["size"]
              lvm_lv_type     = virtual_spaces.value["lvm_lv_type"]
              lvm_path        = virtual_spaces.value["lvm_path"]
              runtime_lv_type = virtual_spaces.value["runtime_lv_type"]
            }
          }
        }
      }
    }
  }
}

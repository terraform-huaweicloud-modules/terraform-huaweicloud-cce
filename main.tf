data "huaweicloud_availability_zones" "this" {
  count = length(var.availability_zones) < 1 ? 1 : 0
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
  eip                    = var.clusetr_eip_address

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
    for_each = var.custom_az_used && length(var.cluster_multi_availability_zones) > 0 ? var.cluster_multi_availability_zones : length(var.availability_zones) > 0 ? slice(var.availability_zones, 0, var.az_count) : slice(data.huaweicloud_availability_zones.this[0].names, 0, var.az_count)

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
  count = var.is_cluster_create && var.is_node_pool_create ? 1 : 0

  cluster_id         = huaweicloud_cce_cluster.this[0].id
  name               = var.name_suffix != "" ? format("%s-%s", var.node_pool_name, var.name_suffix) : var.node_pool_name
  initial_node_count = var.node_pool_initial_node_count
  flavor_id          = var.node_pool_flavor
  type               = var.node_pool_type
  availability_zone  = length(var.availability_zones) > 0 ? var.availability_zones[0] : data.huaweicloud_availability_zones.this[0].names[0]
  os                 = var.node_pool_os_type
  key_pair           = var.keypair_name
  password           = var.node_pool_password
  subnet_id          = var.subnet_id
  ecs_group_id       = var.node_pool_ecs_group_id

  extend_param = var.node_pool_extend_params

  scall_enable             = var.node_pool_scale_enable
  min_node_count           = var.node_pool_min_node_count
  max_node_count           = var.node_pool_max_node_count
  scale_down_cooldown_time = var.node_pool_scale_down_cooldown_time
  priority                 = var.node_pool_priority
  security_groups          = var.node_pool_security_groups
  pod_security_groups      = var.node_pool_pod_security_groups
  initialized_conditions   = var.node_pool_initialized_conditions
  labels                   = var.node_pool_k8s_labels
  tags = merge(
    { "Name" = var.name_suffix != "" ? format("%s-%s", var.node_pool_name, var.name_suffix) : var.node_pool_name },
  var.node_pool_tags)
  runtime = var.node_pool_runtime

  dynamic "taints" {
    for_each = var.node_pool_taint_configuration

    content {
      key    = taints.value["key"]
      value  = taints.value["value"]
      effect = taints.value["effect"]
    }
  }

  root_volume {
    volumetype    = var.node_pool_root_volume_configuration["type"]
    size          = var.node_pool_root_volume_configuration["size"]
    extend_params = var.node_pool_root_volume_configuration["extend_params"]
    kms_key_id    = var.node_pool_root_volume_configuration["kms_key_id"]
    dss_pool_id   = var.node_pool_root_volume_configuration["dss_pool_id"]
  }

  dynamic "data_volumes" {
    for_each = var.node_pool_data_volumes_configuration

    content {
      volumetype    = data_volumes.value["type"]
      size          = data_volumes.value["size"]
      extend_params = data_volumes.value["extend_params"]
      kms_key_id    = data_volumes.value["kms_key_id"]
      dss_pool_id   = data_volumes.value["dss_pool_id"]
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
}

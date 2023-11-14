# The Terraform module of HUAWEI Cloud CCE service

The terraform module for one-click deployment of CCE Cluster and related resources.

## Usage

```hcl
variable "vpc_id" {}
variable "subnet_id" {}
variable "availability_zones" {
  type = list(string)
}
variable "cce_cluster_type" {}
variable "cce_cluster_flavor" {}
variable "cce_container_network_type" {}
variable "cce_container_network_cidr" {}
variable "cce_cluster_name" {}
variable "cce_cluster_authentication_mode" {}
variable "cce_node_name" {}
variable "cce_node_flavor" {}
variable "cce_node_keypair_name" {}
variable "cce_node_root_volume_configuration" {}
variable "cce_node_data_volumes_configuration" {}
variable "cce_node_storage_configuration" {}

module "cce_service" {
  source = "terraform-huaweicloud-modules/terraform-huaweicloud-cce"

  vpc_id             = var.vpc_id
  subnet_id          = var.subnet_id
  availability_zones = var.availability_zones

  cluster_type           = var.cce_cluster_type
  cluster_flavor         = var.cce_cluster_flavor
  container_network_type = var.cce_container_network_type
  container_network_cidr = var.cce_container_network_cidr
  cluster_name           = var.cce_cluster_name
  authentication_mode    = var.cce_cluster_authentication_mode
  is_delete_all          = true

  node_name                       = var.cce_node_name
  node_flavor                     = var.cce_node_flavor
  keypair_name                    = var.cce_node_keypair_name
  node_root_volume_configuration  = var.cce_node_root_volume_configuration
  node_data_volumes_configuration = var.cce_node_data_volumes_configuration
  node_storage_configuration      = var.cce_node_storage_configuration

  node_pools_configuration = [
    {
      name               = "simple-cce-node-pool-via-modules"
      flavor_id          = "s6.large.2"
      os                 = "EulerOS 2.9"
      initial_node_count = 1
      password           = "Test@123"
      tags = {
        Creator = "terraform-huaweicloud-cce"
      }

      data_volumes = [{
        type = "ESSD"
        size = 100
      }]

      extend_params = {
        max_pods = 5
      }
    }
  ]
}
```

## Contributing

Report issues/questions/feature requests in the [issues](https://github.com/terraform-huaweicloud-modules/terraform-huaweicloud-cce/issues/new)
section.

Full contributing [guidelines are covered here](.github/how_to_contribute.md).

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.3.0 |
| Huaweicloud Provider | >= 1.57.0 |

## Resources

| Name | Type |
|------|------|
| huaweicloud_cce_cluster.this | resource |
| huaweicloud_cce_node.this | resource |
| huaweicloud_cce_node_pool.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| charging_mode | The charging mode of the CCE resources | string | null | N |
| period_unit | The period unit of the pre-paid purchase | string | null | N |
| period | The period number of the pre-paid purchase | number | null | N |
| is_auto_renew | Whether to automatically renew after expiration for CCE resourcess | bool | null | N |
| name_suffix | The suffix string of name for all CCE resources | string | "" | N |
| vpc_id | The ID of the VPC to which the CCE resources belongs | string | null | N |
| subnet_id | The ID of the VPC subnet to which the CCE resources belongs | string | null | N |
| subnet_fixed_ip | The fixed IP of the related subnet of the CCE node | string | null | N |
| availability_zones | The list of availability zones where the CCE resources are located | list(string) | [] | N |
| is_cluster_create | Controls whether a CCE cluster should be created (it affects all CCE related resources under this module) | bool | true | N |
| cluster_type | The type of the CCE cluster | string | "VirtualMachine" | N |
| cluster_version | The specified version of the CCE cluster | string | null | N |
| cluster_flavor | The flavor ID (e.g. cce.s2.medium) of the CCE cluster | string | null | N |
| container_network_type | The container network type of the CCE cluster | string | null | N |
| container_network_cidr | The container network CIDR of the CCE cluster | string | null | N |
| service_network_cidr | The service network type of the CCE cluster | string | null | N |
| cluster_public_access | Whether to enable public access of the CCE cluster | bool |false | N |
| cluster_eip_address | The EIP address of the CCE cluster | string | null | N |
| cluster_eip_type | The EIP type of the CCE cluster | string | 5_bgp | N |
| cluster_eip_bandwidth_name | The EIP bandwidth name of CCE cluster | string | null | N |
| cluster_eip_bandwidth_charge_mode | The EIP bandwidth charge mode of CCE cluster | string | traffic | N |
| cluster_eip_bandwidth_size | The EIP bandwidth size of CCE cluster | string | 8 | N |
| cluster_eip_bandwidth_share_type | The EIP bandwidth share type of CCE cluster | string | PER | N |
| eni_subnet_id | The ID of the VPC subnet for CCE turbo resource creation | string | null | N |
| cluster_name | The name of the CCE cluster | string | "" | N |
| cluster_description | The description content of the CCE cluster | string | null | N |
| enterprise_project_id | The ID of the enterprise project to which the CCE cluster belongs | string | null | N |
| authentication_mode | The authentication mode of the CCE cluster | string | null | N |
| authenticating_proxy_ca | The x509 CA certificate of the authentication proxy of the CCE cluster | string | null | N |
| authenticating_proxy_cert | The client certificate of the authentication proxy of the CCE cluster | string | null | N |
| authenticating_proxy_private_key | The private key of the authentication proxy of the CCE cluster | string | null | N |
| kube_proxy_mode | The service forwarding mode of the CCE cluster | string | null | N |
| cluster_extend_params | The extend parameters of the CCE cluster | map(string) | null | N |
| cluster_multi_availability_zones | The list of availability zones where the CCE cluster is located | list(string) | [] | N |
| az_count | The number of availability zones which will resource used | number | 1 | N |
| cluster_tags | The tags of CCE cluster | map(string) | null | N |
| is_delete_evs | Whether to delete associated EVS disks when deleting the CCE cluster | bool | null | N |
| is_delete_obs | Whether to delete associated OBS buckets when deleting the CCE cluster | bool | null | N |
| is_delete_sfs | Whether to delete associated SFS file systems when deleting the CCE cluster | bool | null | N |
| is_delete_efs | Whether to delete associated SFS Turbos when deleting the CCE cluster | bool | null | N |
| is_delete_all | Whether to delete all associated resources when deleting the CCE cluster | bool | null | N |
| is_node_create | Controls whether one or more CCE nodes should be created | bool | null | N |
| node_name | The name of the CCE node | string | null | N |
| node_flavor | The flavor ID of the CCE node | string | null | N |
| os_type | The service forwarding mode | string | null | N |
| runtime | The runtime of the CCE node | string | null | N |
| node_extend_params | The extend parameters of the CCE node | map(string) | null | N |
| ecs_group_id | The ECS server group where the CCE node is located | string | null | N |
| max_pods_number | The maximum number of CCE pods allowed to be created | string | null | N |
| eip_id | The elastic IP associated with the CCE node | string | null | N |
| eip_type | The type of the EIP associated with the CCE node | string | null | N |
| bandwidth_charge_mode | The charge mode of the bandwidth bound to the CCE node | string | null | N |
| bandwidth_size | The size of the bandwidth bound to the CCE node | string | null | N |
| bandwidth_share_type | The share type of the bandwidth bound to the CCE node | string | null | N |
| node_taint_configuration | The anti-affinity configuration of the CCE node | <pre>list(object({<br>  key    = string<br>  value  = string<br>  effect = string<br>}))</pre> | [] | N |
| node_password | The password of the CCE node | string | null | N |
| pre_install_script | The script to be executed before installation | string | null | N |
| post_install_script | The script to be executed after installation | string | null | N |
| node_root_volume_configuration | The configuration of root volume of the CCE node | <pre>object({<br>  type          = string<br>  size          = number<br>  extend_params = map(string)<br>})</pre> | <pre>{<br>  type = "ESSD"<br>  size = 50<br>}</pre> | N |
| node_data_volumes_configuration | The configuration of data volumes of the CCE node | <pre>list(object({<br>  type          = string<br>  size          = number<br>  extend_params = map(string)<br>  kms_key_id    = string<br>}))</pre> | <pre>[<br>  {<br>    type = "ESSD"<br>    size = 100<br>  }<br>]</pre> | N |
| node_storage_configuration | The configuration of the CCE node storage | <pre>object({<br>  selectors = list(object({<br>    name                           = string<br>    type                           = string<br>    match_label_size               = number<br>    match_label_volume_type        = string<br>    match_label_metadata_encrypted = string<br>    match_label_metadata_cmkid     = string<br>    match_label_count              = number<br>  }))<br>  groups = list(object({<br>    name           = string<br>    selector_names = list(string)<br>    cce_managed    = string<br>    virtual_spaces = list(object({<br>      name            = string<br>      size            = string<br>      lvm_lv_type     = string<br>      lvm_path        = string<br>      runtime_lv_type = string<br>    }))<br>  }))<br>})</pre> | null | N |
| node_k8s_labels | The kubernetes labels configuration of the CCE node | map(string) | null | N |
| node_tags | The tags configuration of the CCE node | map(string) | null | N |
| keypair_name | The name of the key-pair for encryption | string | null | N |
| node_pools_configuration | The configuration of the CCE node pools | <pre>type = list(object({<br>  name                     = optional(string, null)<br>  initial_node_count       = optional(number, 1)<br>  flavor_id                = optional(string, null)<br>  type                     = optional(string, null)<br>  os                       = optional(string, "EulerOS 2.9")<br>  key_pair                 = optional(string, null)<br>  password                 = optional(string, null)<br>  ecs_group_id             = optional(string, null)<br>  extend_param             = optional(map(string), null)<br>  scale_enable             = optional(bool, null)<br>  min_node_count           = optional(number, null)<br>  max_node_count           = optional(number, null)<br>  scale_down_cooldown_time = optional(number, null)<br>  priority                 = optional(number, null)<br>  security_groups          = optional(list(string), null)<br>  pod_security_groups      = optional(list(string), null)<br>  initialized_conditions   = optional(list(string), null)<br>  labels                   = optional(map(string), null)<br>  tags                     = optional(map(string), null)<br>  runtime                  = optional(string, null)<br><br>  extend_params = optional(object({<br>    max_pods            = optional(number, null)<br>    docker_base_size    = optional(number, null)<br>    preinstall          = optional(string, null)<br>    postinstall         = optional(string, null)<br>    node_image_id       = optional(string, null)<br>    node_multi_queue    = optional(string, null)<br>    nic_threshold       = optional(string, null)<br>    agency_name         = optional(string, null)<br>    kube_reserved_mem   = optional(number, null)<br>    system_reserved_mem = optional(number, null)<br>    }),<br>    null<br>  )<br><br>  taints = optional(list(object({<br>    key    = string<br>    value  = string<br>    effect = string<br>    })),<br>    []<br>  )<br><br>  root_volume = optional(object({<br>    type          = optional(string, "ESSD")<br>    size          = optional(number, 50)<br>    extend_params = optional(map(string), null)<br>    kms_key_id    = optional(string, null)<br>    dss_pool_id   = optional(string, null)<br>    }),<br>    {<br>      type = "ESSD"<br>      size = 50<br>    }<br>  )<br><br>  data_volumes = optional(list(object({<br>    type          = optional(string, "ESSD")<br>    size          = optional(number, 100)<br>    extend_params = optional(map(string), null)<br>    kms_key_id    = optional(string, null)<br>    dss_pool_id   = optional(string, null)<br>    })),<br>    [<br>      {<br>        type = "ESSD"<br>        size = 100<br>      }<br>    ]<br>  )<br><br>  storage = optional(object({<br>    selectors = optional(list(object({<br>      name                           = string<br>      type                           = optional(string, "evs")<br>      match_label_size               = optional(number, 100)<br>      match_label_volume_type        = optional(string, null)<br>      match_label_metadata_encrypted = optional(string, null)<br>      match_label_metadata_cmkid     = optional(string, null)<br>      match_label_count              = optional(number, null)<br>    })), null)<br>    groups = optional(list(object({<br>      name           = string<br>      selector_names = list(string)<br>      cce_managed    = optional(string, null)<br>      virtual_spaces = list(object({<br>        name            = string<br>        size            = string<br>        lvm_lv_type     = optional(string, null)<br>        lvm_path        = optional(string, null)<br>        runtime_lv_type = optional(string, null)<br>      }))<br>    })), null)<br>    }),<br>    null<br>  )<br>}))</pre> | [] | N |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | The CCE cluster ID (When multiple clusters are created, the ID of the first cluster is returned) |
| cluster_ids | The ID list of all CCE cluster resources |
| clsuter_security_group_ids | The ID list of the security groups to which each CCE cluster resource belongs |
| cluster_statuses | The status list for all CCE cluster resources |
| cluster_kube_config_raw | The raw Kubernetes config to be used by kubectl and other compatible tools |
| cluster_certificate_clusters | The certificate clusters |
| cluster_certificate_users | The certificate users |
| node_id | The CCE node ID (When multiple nodes are created, the ID of the first node is returned) |
| node_ids | The ID list for all CCE node resources |
| node_public_ips | The list of public IP addresses for all CCE node resources |
| node_pool_id | The CCE node pool ID |
| node_pool_ids | The ID list for all CCE node pool resources |

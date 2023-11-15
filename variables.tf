######################################################################
# Attributes of the CBC payment
######################################################################

variable "charging_mode" {
  description = "The charging mode of the CCE resources"

  type    = string
  default = null
}

variable "period_unit" {
  description = "The period unit of the pre-paid purchase"

  type    = string
  default = null
}

variable "period" {
  description = "The period number of the pre-paid purchase"

  type    = number
  default = null
}

variable "is_auto_renew" {
  description = "Whether to automatically renew after expiration for CCE resources"

  type    = bool
  default = null
}

######################################################################
# Public configurations
######################################################################

# Specifies the suffix name for CCE resources, if omitted, using cluster_name, node_name to create CCE resources
variable "name_suffix" {
  description = "The suffix string of name for all CCE resources"

  type    = string
  default = ""
}

######################################################################
# Attributes of the VPC resources
######################################################################

variable "vpc_id" {
  description = "The ID of the VPC to which the CCE resources belongs"

  type    = string
  default = null
}

variable "subnet_id" {
  description = "The ID of the VPC subnet to which the CCE resources belongs"

  type    = string
  default = null
}

variable "availability_zones" {
  description = "The list of availability zones where the CCE resources are located"

  type    = list(string)
  default = []
}

######################################################################
# Configuration of CCE resources
######################################################################

variable "is_cluster_create" {
  description = "Controls whether a CCE cluster should be created (it affects all CCE related resources under this module)"

  type    = bool
  default = true
}

variable "cluster_type" {
  description = "The type of the CCE cluster"

  type    = string
  default = "VirtualMachine"
}

variable "cluster_version" {
  description = "The specified version of the CCE cluster"

  type    = string
  default = null
}

variable "cluster_flavor" {
  description = "The flavor ID (e.g. cce.s2.medium) of the CCE cluster"

  type    = string
  default = null
}

variable "container_network_type" {
  description = "The container network type of the CCE cluster"

  type    = string
  default = null
}

variable "container_network_cidr" {
  description = "The container network CIDR of the CCE cluster"

  type    = string
  default = null
}

variable "service_network_cidr" {
  description = "The service network CIDR of the CCE cluster"

  type    = string
  default = null
}

variable "cluster_public_access" {
  description = "Whether to enable public access of the CCE cluster"

  type    = bool
  default = false
}

variable "cluster_eip_address" {
  description = "The EIP address of the CCE cluster"

  type    = string
  default = null
}

variable "cluster_eip_type" {
  description = "The EIP type of the CCE cluster"

  type    = string
  default = "5_bgp"
}

variable "cluster_eip_bandwidth_name" {
  description = "The EIP bandwidth name of CCE cluster"

  type    = string
  default = null
}

variable "cluster_eip_bandwidth_charge_mode" {
  description = "The EIP bandwidth charge mode of CCE cluster"

  type    = string
  default = "traffic"
}

variable "cluster_eip_bandwidth_size" {
  description = "The EIP bandwidth size of CCE cluster"

  type    = string
  default = 8
}

variable "cluster_eip_bandwidth_share_type" {
  description = "The EIP bandwidth share type of CCE cluster"

  type    = string
  default = "PER"
}

# Network configuration for CCE Turbo
variable "eni_subnet_ids" {
  description = "The ID of the VPC subnet for CCE turbo resource creation"

  type    = list(string)
  default = []
}

variable "cluster_name" {
  description = "The name of the CCE cluster"

  type    = string
  default = null
}

variable "cluster_description" {
  description = "The description content of the CCE cluster"

  type    = string
  default = null
}

variable "enterprise_project_id" {
  description = "The ID of the enterprise project to which the CCE cluster belongs"

  type    = string
  default = null
}

variable "authentication_mode" {
  description = "The authentication mode of the CCE cluster"

  type    = string
  default = null
}

variable "authenticating_proxy_ca" {
  description = "The x509 CA certificate of the authentication proxy of the CCE cluster"

  type    = string
  default = null
}

variable "authenticating_proxy_cert" {
  description = "The client certificate of the authentication proxy of the CCE cluster"

  type    = string
  default = null
}

variable "authenticating_proxy_private_key" {
  description = "The private key of the authentication proxy of the CCE cluster"

  type    = string
  default = null
}

variable "kube_proxy_mode" {
  description = "The service forwarding mode of the CCE cluster"

  type    = string
  default = null
}

variable "cluster_extend_params" {
  description = "The extend parameters of the CCE cluster"

  type    = map(string)
  default = null
}

variable "cluster_multi_availability_zones" {
  description = "The list of availability zones where the CCE cluster is located"

  type    = list(string)
  default = []
}

variable "cluster_tags" {
  description = "The tags of CCE cluster"

  type    = map(string)
  default = null
}

variable "is_delete_evs" {
  description = "Whether to delete associated EVS disks when deleting the CCE cluster"

  type    = bool
  default = null
}

variable "is_delete_obs" {
  description = "Whether to delete associated OBS buckets when deleting the CCE cluster"

  type    = bool
  default = null
}

variable "is_delete_sfs" {
  description = "Whether to delete associated SFS file systems when deleting the CCE cluster"

  type    = bool
  default = null
}

variable "is_delete_efs" {
  description = "Whether to delete associated SFS Turbos when deleting the CCE cluster"

  type    = bool
  default = null
}

variable "is_delete_all" {
  description = "Whether to delete all associated resources when deleting the CCE cluster"

  type    = bool
  default = null
}

variable "nodes_configuration" {
  description = "The configuration of the CCE nodes"
  type = list(object({
    name                   = optional(string, null)
    flavor_id              = optional(string, null)
    os                     = optional(string, "EulerOS 2.9")
    key_pair               = optional(string, null)
    password               = optional(string, null)
    private_key            = optional(string, null)
    fixed_ip               = optional(string, null)
    ecs_group_id           = optional(string, null)
    dedicated_host_id      = optional(string, null)
    initialized_conditions = optional(list(string), null)
    labels                 = optional(map(string), null)
    tags                   = optional(map(string), null)
    runtime                = optional(string, null)

    eip_id                = optional(string, null)
    iptype                = optional(string, null)
    bandwidth_charge_mode = optional(string, null)
    bandwidth_size        = optional(string, null)
    sharetype             = optional(string, null)

    extend_params = optional(object({
      max_pods            = optional(number, null)
      docker_base_size    = optional(number, null)
      preinstall          = optional(string, null)
      postinstall         = optional(string, null)
      node_image_id       = optional(string, null)
      node_multi_queue    = optional(string, null)
      nic_threshold       = optional(string, null)
      agency_name         = optional(string, null)
      kube_reserved_mem   = optional(number, null)
      system_reserved_mem = optional(number, null)
      }),
      null
    )

    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
      })),
      []
    )

    root_volume = optional(object({
      type          = optional(string, "SSD")
      size          = optional(number, 50)
      extend_params = optional(map(string), null)
      kms_key_id    = optional(string, null)
      dss_pool_id   = optional(string, null)
      }),
      {
        type = "SSD"
        size = 50
      }
    )

    data_volumes = optional(list(object({
      type          = optional(string, "SSD")
      size          = optional(number, 100)
      extend_params = optional(map(string), null)
      kms_key_id    = optional(string, null)
      dss_pool_id   = optional(string, null)
      })),
      [
        {
          type = "SSD"
          size = 100
        }
      ]
    )

    storage = optional(object({
      selectors = optional(list(object({
        name                           = string
        type                           = optional(string, "evs")
        match_label_size               = optional(number, 100)
        match_label_volume_type        = optional(string, null)
        match_label_metadata_encrypted = optional(string, null)
        match_label_metadata_cmkid     = optional(string, null)
        match_label_count              = optional(number, null)
      })), null)
      groups = optional(list(object({
        name           = string
        selector_names = list(string)
        cce_managed    = optional(string, null)
        virtual_spaces = list(object({
          name            = string
          size            = string
          lvm_lv_type     = optional(string, null)
          lvm_path        = optional(string, null)
          runtime_lv_type = optional(string, null)
        }))
      })), null)
      }),
      null
    )
  }))

  default = []
}

variable "node_pools_configuration" {
  description = "The configuration of the CCE node pools"
  type = list(object({
    name                     = optional(string, null)
    initial_node_count       = optional(number, 1)
    flavor_id                = optional(string, null)
    type                     = optional(string, null)
    os                       = optional(string, "EulerOS 2.9")
    key_pair                 = optional(string, null)
    password                 = optional(string, null)
    ecs_group_id             = optional(string, null)
    scale_enable             = optional(bool, null)
    min_node_count           = optional(number, null)
    max_node_count           = optional(number, null)
    scale_down_cooldown_time = optional(number, null)
    priority                 = optional(number, null)
    security_groups          = optional(list(string), null)
    pod_security_groups      = optional(list(string), null)
    initialized_conditions   = optional(list(string), null)
    labels                   = optional(map(string), null)
    tags                     = optional(map(string), null)
    runtime                  = optional(string, null)

    extend_params = optional(object({
      max_pods            = optional(number, null)
      docker_base_size    = optional(number, null)
      preinstall          = optional(string, null)
      postinstall         = optional(string, null)
      node_image_id       = optional(string, null)
      node_multi_queue    = optional(string, null)
      nic_threshold       = optional(string, null)
      agency_name         = optional(string, null)
      kube_reserved_mem   = optional(number, null)
      system_reserved_mem = optional(number, null)
      }),
      null
    )

    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
      })),
      []
    )

    root_volume = optional(object({
      type          = optional(string, "SSD")
      size          = optional(number, 50)
      extend_params = optional(map(string), null)
      kms_key_id    = optional(string, null)
      dss_pool_id   = optional(string, null)
      }),
      {
        type = "SSD"
        size = 50
      }
    )

    data_volumes = optional(list(object({
      type          = optional(string, "SSD")
      size          = optional(number, 100)
      extend_params = optional(map(string), null)
      kms_key_id    = optional(string, null)
      dss_pool_id   = optional(string, null)
      })),
      [
        {
          type = "SSD"
          size = 100
        }
      ]
    )

    storage = optional(object({
      selectors = optional(list(object({
        name                           = string
        type                           = optional(string, "evs")
        match_label_size               = optional(number, 100)
        match_label_volume_type        = optional(string, null)
        match_label_metadata_encrypted = optional(string, null)
        match_label_metadata_cmkid     = optional(string, null)
        match_label_count              = optional(number, null)
      })), null)
      groups = optional(list(object({
        name           = string
        selector_names = list(string)
        cce_managed    = optional(string, null)
        virtual_spaces = list(object({
          name            = string
          size            = string
          lvm_lv_type     = optional(string, null)
          lvm_path        = optional(string, null)
          runtime_lv_type = optional(string, null)
        }))
      })), null)
      }),
      null
    )
  }))

  default = []
}

######################################################################
# DEW input parameters for CCE resources
######################################################################

variable "keypair_name" {
  description = "The name of the key-pair for encryption"

  type    = string
  default = null
}

######################################################################
# Deprecated variables
######################################################################

variable "eni_subnet_cidr" {
  description = "The CIDR of the VPC subnet for CCE turbo resource creation"

  type    = string
  default = null
}

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

variable "subnet_fixed_ip" {
  description = "The fixed IP of the related subnet of the CCE node"

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

# Network configuration for CCE Turbo
variable "eni_subnet_id" {
  description = "The ID of the VPC subnet for CCE turbo resource creation"

  type    = string
  default = null
}

variable "cluster_name" {
  description = "The name of the CCE cluster"

  type    = string
  default = ""
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

variable "custom_az_used" {
  description = "Whether to use a custom list of Availability Zones"

  type    = bool
  default = false
}

variable "cluster_multi_availability_zones" {
  description = "The list of availability zones where the CCE cluster is located"

  type    = list(string)
  default = []
}

variable "az_count" {
  description = "The number of availability zones which will resource used"

  type    = number
  default = 1

  validation {
    condition = var.az_count >= 1 && var.az_count <= 3
    error_message = format("Invalid value of availability zone count, want [1, 3], but %d", var.az_count)
  }
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

variable "is_node_create" {
  description = "Controls whether one or more CCE nodes should be created"

  type    = bool
  default = true
}

variable "node_name" {
  description = "The name of the CCE node"

  type    = string
  default = null
}

variable "node_flavor" {
  description = "The flavor ID of the CCE node"

  type    = string
  default = null
}

variable "os_type" {
  description = "The service forwarding mode"

  type    = string
  default = null
}

variable "runtime" {
  description = "The runtime of the CCE node"

  type    = string
  default = null
}

variable "node_extend_params" {
  description = "The extend parameters of the CCE node"

  type    = map(string)
  default = null
}

variable "ecs_group_id" {
  description = "The ECS server group where the CCE node is located"

  type    = string
  default = null
}

variable "max_pods_number" {
  description = "The maximum number of CCE pods allowed to be created"

  type    = string
  default = null
}

variable "eip_id" {
  description = "The elastic IP associated with the CCE node"

  type    = string
  default = null
}

# If the EIP type is not empty, the bandwidth size and sharing type must be configured
variable "eip_type" {
  description = "The type of the EIP associated with the CCE node"

  type    = string
  default = null
}

variable "bandwidth_charge_mode" {
  description = "The charge mode of the bandwidth bound to the CCE node"

  type    = string
  default = null
}

variable "bandwidth_size" {
  description = "The size of the bandwidth bound to the CCE node"

  type    = string
  default = null
}

variable "bandwidth_share_type" {
  description = "The share type of the bandwidth bound to the CCE node"

  type    = string
  default = null
}

variable "node_taint_configuration" {
  description = "The anti-affinity configuration of the CCE node"

  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default = []
}

variable "node_password" {
  description = "The service forwarding mode"

  type    = string
  default = null
}

variable "pre_install_script" {
  description = "The script to be executed before installation"

  type    = string
  default = null
}

variable "post_install_script" {
  description = "The script to be executed after installation"

  type    = string
  default = null
}

variable "node_root_volume_configuration" {
  description = "The configuration of root volume of the CCE node"

  type = object({
    type          = optional(string, "SSD")
    size          = optional(number, 100)
    extend_params = optional(map(string), null)
  })

  default = {
    type = "SSD"
    size = 100
  }
}

variable "node_data_volumes_configuration" {
  description = "The configuration of data volumes of the CCE node"

  type = list(object({
    type          = optional(string, "SSD")
    size          = optional(number, 200)
    extend_params = optional(map(string), null)
    kms_key_id    = optional(string, null)
  }))

  default = [
    {
      type = "SSD"
      size = 200
    }
  ]
}

variable "node_storage_configuration" {
  description = "The configuration of the CCE node storage"

  type = object({
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
  })

  default = null
}

variable "node_k8s_labels" {
  description = "The kubernetes labels configuration of the CCE node"

  type    = map(string)
  default = null
}

variable "node_tags" {
  description = "The tags configuration of the CCE node"

  type    = map(string)
  default = null
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

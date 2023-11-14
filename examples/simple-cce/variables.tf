######################################################################
# Attributes of the VPC resources
######################################################################

variable "vpc_name" {
  description = "The name of the VPC to which the CCE resources belongs"

  type = string
}

variable "vpc_cidr_block" {
  description = "The CIDR of the VPC to which the CCE resources belongs"

  type = string
}

variable "subnets_configuration" {
  description = "The configuration of the subnet resources to which the CCE resources belongs"

  type = list(object({
    name = string
    cidr = string
  }))
}

variable "availability_zones" {
  description = "The specified availability zone where the CCE resources are located"

  type    = list(string)
  default = []
}

######################################################################
# Attributes of the CCE resources
######################################################################

variable "cluster_type" {
  description = "The type of the CCE cluster"

  type    = string
  default = "VirtualMachine"
}

variable "cluster_flavor" {
  description = "The flavor ID (e.g. cce.s2.medium) of the CCE cluster"

  type    = string
  default = "cce.s2.medium"
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

variable "cluster_name" {
  description = "The name of the CCE cluster"

  type    = string
  default = null
}

variable "az_count" {
  description = "The number of availability zones which will the CCE resources are used"

  type    = number
  default = 1

  validation {
    condition     = var.az_count >= 1 && var.az_count <= 3
    error_message = format("Invalid value of availability zone count, want [1, 3], but %d", var.az_count)
  }
}

variable "cluster_tags" {
  description = "The tags of CCE cluster"

  type = map(string)
  default = {
    Creator = "terraform-huaweicloud-cce"
  }
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

variable "node_os_type" {
  description = "Specifies the operating system of the node"

  type    = string
  default = null
}

variable "node_runtime" {
  description = "The runtime of the CCE node"

  type    = string
  default = null
}

variable "node_password" {
  description = "The service forwarding mode"

  type    = string
  default = null
}

variable "node_root_volume_configuration" {
  description = "The configuration of root volume of the CCE node"

  type = object({
    type = string
    size = number
  })

  default = {
    type = "ESSD"
    size = 50
  }
}

variable "node_data_volumes_configuration" {
  description = "The configuration of data volumes of the CCE node"

  type = list(object({
    type = string
    size = number
  }))

  default = [
    {
      type = "ESSD"
      size = 100
    }
  ]
}

variable "node_tags" {
  description = "The tags configuration of the CCE node"

  type = map(string)
  default = {
    Creator = "terraform-huaweicloud-cce"
  }
}

variable "node_pools_configuration" {
  description = "The configuration of the CCE node pools"
  type = list(object({
    name               = optional(string, null)
    initial_node_count = optional(number, null)
    flavor_id          = optional(string, null)
    type               = optional(string, null)
    os                 = optional(string, null)
    tags               = optional(map(string), null)
    runtime            = optional(string, null)
    password           = optional(string, null)

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

    root_volume = optional(object({
      type          = optional(string, "ESSD")
      size          = optional(number, 50)
      extend_params = optional(map(string), null)
      kms_key_id    = optional(string, null)
      dss_pool_id   = optional(string, null)
      }),
      {
        type = "SSD"
        size = 100
      }
    )

    data_volumes = optional(list(object({
      type          = optional(string, "ESSD")
      size          = optional(number, 100)
      extend_params = optional(map(string), null)
      kms_key_id    = optional(string, null)
      dss_pool_id   = optional(string, null)
      })),
      [
        {
          type = "SSD"
          size = 200
        }
      ]
    )
  }))

  default = []
}

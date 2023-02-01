# Simple CCE

Configuration in this directory creates a default CCE cluster, a default CCE node and related VPC resources (VPC and subnet).

Referring to this use case, you can write a basic CCE script.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Node that this example will create some resources and spend a few money.
Run `terraform destory` when you don't need them.

## Requirement

| Name | Version |
|------|---------|
| Terraform | >= 1.3.0 |
| HuaweiCloud | >= 1.40.0 |
| Random | >= 3.0.0 |

## Providers

[terraform-provider-huaweicloud](https://github.com/huaweicloud/terraform-provider-huaweicloud)

## Modules

| Name | Source | Version |
|------|--------|---------|
| cce | [../..](../../README.md) | N/A |
| vpc | [terraform-huaweicloud-vpc] | N/A |

## Resources

| Name | Type |
|------|------|
| random_password.this[0] | resource |
| huaweicloud_vpc.this[0] | resource |
| huaweicloud_vpc_subnet.this[0] | resource |
| huaweicloud_cce_cluster.this[0] | resource |
| huaweicloud_cce_node.this[0] | resource |

## Inputs

| Name | Description | Type | Default Value |
|------|-------------|------|---------------|
| vpc_name | The name of the VPC to which the CCE resources belongs | string | N/A |
| vpc_cidr_block | The CIDR of the VPC to which the CCE resources belongs | string | N/A |
| subnets_configuration | The configuration of the subnet resources to which the CCE resources belongs | <pre>list(object({<br>  name = string<br>  cidr=string}))</pre> | N/A |
| availability_zones | The specified availability zone where the CCE resources are located | list(string) | [] |
| cluster_type | The type of the CCE cluster | string | "VirtualMachine" |
| cluster_flavor | The flavor ID (e.g. cce.s2.medium) of the CCE cluster | string | "cce.s2.medium" |
| container_network_type | The container network type of the CCE cluster | string | N/A |
| container_network_cidr | The container network CIDR of the CCE cluster | string | N/A |
| service_network_cidr | The service network CIDR of the CCE cluster | string | N/A |
| cluster_name | The number of availability zones which will resource used | string | N/A |
| az_count | The number of availability zones which will the CCE resources are used | number | 1 |
| cluster_tags | The tags of CCE cluster | map(string) | <pre>{<br>  Creator = "terraform-huaweicloud-cce"<br>}</pre> |
| node_name | The name of the CCE node | string | null |
| node_flavor | The flavor ID of the CCE node | string | null |
| node_os_type | The operating system of the CCE node | string | null |
| node_runtime | The runtime of the CCE node | string | null |
| node_password | The administrator password used to login CCE node | string | null |
| node_root_volume_configuration | The configuration of root volume of the CCE node | <pre>object({<br>  type = string<br>  size = string<br>})</pre> | <pre>{<br>  type = "SSD"<br>  size = 100<br>}</pre> |
| node_data_volumes_configuration | The configuration of data volumes of the CCE node | <pre>list(object({<br>  type = string<br>  size = string<br>}))</pre> | <pre>[<br>  {<br>    type = "SSD"<br>    size = 200<br>  }<br>]</pre> |
| node_tags | The tags configuration of the CCE node | map(string) | <pre>{<br>  Creator = "terraform-huaweicloud-cce"<br>}</pre> |

output "cluster_id" {
    description = "The CCE cluster ID"
    value       = try(huaweicloud_cce_cluster.this[0].id, "")
}

output "cluster_ids" {
    description = "The ID list for all CCE cluster resources"
    value       = huaweicloud_cce_cluster.this[*].id
}

output "clsuter_security_group_ids" {
    description = "The ID list of the security groups to which each CCE cluster resource belongs"
    value       = huaweicloud_cce_cluster.this[*].security_group_id
}

output "cluster_statuses" {
    description = "The status list for all CCE cluster resources"
    value       = huaweicloud_cce_cluster.this[*].status
}

output "node_id" {
    description = "The CCE node ID"
    value       = try(huaweicloud_cce_node.this[0].id, "")
}

output "node_ids" {
    description = "The ID list for all CCE node resources"
    value       = huaweicloud_cce_node.this[*].id
}

output "node_public_ips" {
    description = "The list of public IP addresses for all CCE node resources"
    value       = huaweicloud_cce_node.this[*].public_ip
}

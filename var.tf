#Ibm part

variable "ibm_api_key" {
  description = "API key."
}

variable "ibm_resource_group" {
  type=string
  default = "ITGP_DATA"
}

variable "ibm_region" {
  type        = string
  default     = "eu-de"
}

#Cluster variables

variable "cluster_name" {
  type        = string
  default     = "cluster_demo_19_11"
}
variable "cluster_datacenter" {
  type        = string
  default     = "fra02"
}

variable "cluster_machine_type" {
  type        = string
  default     = "u2c.2x4"
}
variable "cluster_hardware" {
  type        = string
  default     = "shared"
}

 variable "cluster_public_vlan_id"{
  type        = string
  default     = "2347339"
 }

 variable "cluster_private_vlan_id"{
    type        = string
    default     = "2347341"
 }

#Logging variables
variable "logging_plan" {
    type        = string
    default     = "lite"
}

variable "logdna_namespace" {
  type        = string
  default     = "dnansp"
}

variable "logging_endpoint" {
    type        = string
    default     = "private"
}

variable "logging_instance_name" {
    type        = string
    default     = "logDna-cluster"
}

variable "logging_agent_image" {
    type        = string
    default     = "icr.io/ext/logdna-agent:latest"
}

#SysDig variables


variable monitor_name {
    type        = string
    default     = "sysdig_demo_19_11"
}

variable monitor_endpoint {
  type        = string
  default     = "private" 
}

variable monitor_agent_image {
  type        = string
  default     = "icr.io/ext/sysdig/agent:latest"
}

variable monitor_plan {
  type        = string
  default     = "graduated-tier"
}


# Additional variables
variable tags {
    type        = list(string)
    default     = []
}

variable service_end_points {
  type        = string
  default     = "private"
}




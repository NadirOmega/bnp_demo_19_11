variable resource_group_id {
  
}

variable use_data {
  
}

variable name {
  
}

variable sysdig_role {
  default     = "Manager"
}

variable ibm_region {
  default     = "us-south"
}

variable cluster_name {
  description = "where to install the sysdig"
}

variable sysdig_endpoint {
  default     = "private" 
}

variable sysdig_image {

  default     = "icr.io/ext/sysdig/agent:latest"
}

#optional for sysdig

variable monitor_plan {
  description = "service plan for Monitoring"
  default     = "graduated-tier"
}

variable tags {
  description = "tags for sysdig instance"
  default     = []
}

variable end_points {
  description = "Sets the endpoints for the resources provisioned. Can be `public` or `private`"
  default     = "private"
}

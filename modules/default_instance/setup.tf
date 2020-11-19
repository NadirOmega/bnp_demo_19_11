#Object default class

resource ibm_resource_instance service {
  count             = var.use_data ? 0 : 1
  name              = var.name
  service           = var.service
  plan              = var.plan
  location          = var.ibm_region
  resource_group_id = var.resource_group_id

  parameters = {
    "HMAC"            = var.HMAC ? true : null
    service-endpoints = var.end_points
  }

  tags = var.tags

}

#get datasource of the created instance

data ibm_resource_instance service {
  count             = var.use_data ? 1 : 0
  name              = var.name
  resource_group_id = var.resource_group_id 
  service           = var.service
}

#creat local variable
locals {
  service_id = (
    var.use_data
    ? data.ibm_resource_instance.service.0.id 
    : ibm_resource_instance.service.0.id
  )
}

#OutputVar

output id {
  value       = local.service_id
}



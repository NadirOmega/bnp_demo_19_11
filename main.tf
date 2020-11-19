provider "ibm" {
  ibmcloud_api_key = "${var.ibm_api_key}"
}

data ibm_resource_group group {
  name = "${var.ibm_resource_group}"
}

# creating Kubernetes cluster

resource "ibm_container_cluster" "cluster1_demo" {
  name            = "${var.cluster_name}"
  gateway_enabled = true 
  datacenter      = var.cluster_datacenter
  machine_type    = var.cluster_machine_type
  hardware        = var.cluster_hardware
  default_pool_size = 1
  worker_num=1
  resource_group_id = "${data.ibm_resource_group.group.id}"
  public_vlan_id  = var.cluster_public_vlan_id
  private_vlan_id = var.cluster_private_vlan_id
  private_service_endpoint = true
}

#Define data source to obtain cluster informations

data ibm_container_cluster_config cluster {
  cluster_name_id   = ibm_container_cluster.cluster1_demo.id
  resource_group_id = data.ibm_resource_group.group.id
  admin             = true
}

#Define Kub provider from the local resource

provider kubernetes {
  load_config_file       = false
  host                   = data.ibm_container_cluster_config.cluster.host
  client_certificate     = data.ibm_container_cluster_config.cluster.admin_certificate
  client_key             = data.ibm_container_cluster_config.cluster.admin_key
  cluster_ca_certificate = data.ibm_container_cluster_config.cluster.ca_certificate
}

#LogDna init

module logging {
    source             = "./modules/log_dna"
    resource_group_id  = data.ibm_resource_group.group.id
    use_data           = false
    ibm_region         = var.ibm_region
    name               = var.logging_instance_name
    logdna_agent_image = var.logging_agent_image
    logdna_endpoint    = var.logging_endpoint
    logging_plan       = "lite"
    #tags               = var.tags
    end_points         = "public"
}


#deploy cassandra using Helm 
  #config helm provider
provider "helm" {
  kubernetes {
  config_path = "${data.ibm_container_cluster_config.cluster.config_file_path}"
  load_config_file       = false
    host                   = "${data.ibm_container_cluster_config.cluster.host}"
    client_certificate     = "${data.ibm_container_cluster_config.cluster.admin_certificate}"
    client_key             = "${data.ibm_container_cluster_config.cluster.admin_key}"
    cluster_ca_certificate = "${data.ibm_container_cluster_config.cluster.ca_certificate}"
  }
}

  #deploy a helm container
resource "helm_release" "cassandra" {
   create_namespace =true
   namespace = "test2"
   name      = "cassandratestwarm2"
   repository = "https://charts.bitnami.com/ibm"
   chart     = "cassandra"
   timeout = 600
   cleanup_on_fail = true  
   #set additional specification
   
  set {
    name  = "persistence.enabled"
    value = "false"
  }
}

#Sysdig Part
/*
  #Define local variable for image pull
locals {
  image_pull_secrets = [
      "all-icr-io"
    ]
} 



  #Create Namespace & config kub 4 monitoring


resource kubernetes_namespace ibm_observe {
  metadata {
    name = "ibm-observe"
  }
}


data kubernetes_secret image_pull_secret {
  count = length(local.image_pull_secrets)
  metadata {
    name = element(local.image_pull_secrets, count.index)
  }
}



resource kubernetes_secret copy_image_pull_secret {
  count = length(local.image_pull_secrets)
  metadata {
    name      = "ibm-observe-${element(local.image_pull_secrets, count.index)}"
    namespace = kubernetes_namespace.ibm_observe.metadata.0.name
  }
  data      = {
    ".dockerconfigjson" = data.kubernetes_secret.image_pull_secret[count.index].data[".dockerconfigjson"]
  }
  type = "kubernetes.io/dockerconfigjson"
}

  #SysDig Initialisation

  module monitor {
    source             = "./modules/sys_dig"
    resource_group_id  = data.ibm_resource_group.group.id
    use_data           = false
    ibm_region         = var.ibm_region
    name               = var.monitor_name
    cluster_name       = var.cluster_name
    sysdig_image       = var.monitor_agent_image
    sysdig_endpoint    = var.monitor_endpoint
    monitor_plan       = var.monitor_plan
    #tags               = var.tags
    end_points         = var.service_end_points
}*/



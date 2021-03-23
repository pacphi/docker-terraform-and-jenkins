module "tkgi_cluster" {
  source = "git::https://github.com/warroyo/terraforming-tkgi.git//modules/cluster/tkgi"

    tkgi_api_url = var.tkgi_api_url
    tkgi_skip_ssl_validation = var.tkgi_skip_ssl_validation
    tkgi_user = var.tkgi_user
    tkgi_password = var.tkgi_password
    tkgi_cluster_name = var.tkgi_cluster_name
    tkgi_plan = var.tkgi_plan
    tkgi_worker_count = var.tkgi_worker_count
    tkgi_external_hostname = var.tkgi_external_hostname
    tkgi_tags = var.tkgi_tags
}

variable "tkgi_api_url" {
  description = "The URL to reach the TKGI API"
}

variable "tkgi_skip_ssl_validation" {
  description = "Whether or not to skip SSL validation"
  default = false
}

variable "tkgi_password" {
  description = "The TKGI API password for the account used to provision the cluster"
  sensitive =  true
}

variable "tkgi_user" {
  description = "The TKGI API username of the account used to provision the cluster"
}

variable "tkgi_cluster_name" {
  description = "The name assigned to the cluster"
}

variable "tkgi_plan" {
  description = "The plan to use when creating the cluster (e.g., \"small\")"
  default = "small"
}

variable "tkgi_worker_count" {
  description = "The number of worker nodes desired. (Overrides the amount defined in the plan)."
  default = 3
}

variable "tkgi_external_hostname" {
  description = "Hostname for the cluster"
}

variable "tkgi_tags" {
  description = "Tags to be added to the nodes in cluster"
}
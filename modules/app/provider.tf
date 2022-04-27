provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = var.cluster_ca_certificate
    token                  = var.cluster_auth_token
  }
}

provider "kubernetes" {
  host                   = var.cluster_endpoint 
  token                  = var.cluster_auth_token
  cluster_ca_certificate = var.cluster_ca_certificate
}

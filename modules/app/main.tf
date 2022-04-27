# App manifests

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx"
    labels = {
      app = "nginx"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          image = "nginx:1.21.6"
          name  = "nginx"
          volume_mount {
             mount_path = "/var/www/html"
             name      = kubernetes_persistent_volume.nginx.metadata.0.name
          }
          }
        volume {
          name = kubernetes_persistent_volume.nginx.metadata.0.name
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.nginx.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb-ip"      
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.nginx.metadata.0.labels.app
    }
    port {
      port        = 80
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress" "nginx" {
  metadata {
    name = "nginx"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"      
    }
  }

  spec {
    backend {
      service_name = "nginx"
      service_port = 80
    }

    rule {
      http {
        path {
          backend {
            service_name = "nginx"
            service_port = 80
          }

          path = "/"
        }
        }
      }
    }
}


# App volumes
resource "kubernetes_storage_class" "efs" {
  metadata {
    name = "efs-sc"
  }
  storage_provisioner = "efs.csi.aws.com"
  reclaim_policy      = "Retain"
  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId = var.efs_id 
    directoryPerms = "700"
    gidRangeStart = "1000"
    gidRangeEnd = "2000"
  }
  mount_options = ["tls"]
}

resource "kubernetes_persistent_volume" "nginx" {
  metadata {
    name = "nginx-data"
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "efs-sc" 
    capacity = {
      storage = "2Gi"
    }
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = var.efs_id
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "nginx" {
  metadata {
    name = "nginx-data-claim"
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "efs-sc"
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    volume_name = kubernetes_persistent_volume.nginx.metadata.0.name
  }
}

resource "helm_release" "efs_csi_driver" {
  name       = "aws-efs-csi-driver" 
  chart      = "aws-efs-csi-driver"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  version    = "1.2.4"
}

resource "helm_release" "ingress-nginx" {
  name  = "ingress-nginx"
  namespace = "ingress-nginx"
  chart = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version = "3.23.0"
  create_namespace = true

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
    type = "string"
    value = "true"
  }
  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    type = "string"
    value = "tcp"
  }
  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    type = "string"
    value = "nlb"
  }
  set {
    name = "controller.extraArgs.enable-ssl-chain-completion"
    value = "true"
  }
  set {
    name  = "controller.admissionWebhooks.enabled"
    value = "false"
  }
}

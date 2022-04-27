# EKS App

## To create the infrastructure
```bash
$ terraform init
$ terraform plan
$ terraform apply
```
## Login to EKS cluster
```bash
aws eks update-kubeconfig \                                 
  --name dev-eks-cluster --region us-east-1
```
## Things to be improved
* Add tags to resources
* Adjust variables for node groups

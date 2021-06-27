# Cherry Syte
Sweet little exercise in bundling up Docker based apps.

## Building the App image
```
cd <repo_directory>
docker build -t cherry-syte .
```

## Running the App locally
```
docker run -p 5000:5000 cherry-syte
```

## App responses
To get the server IP and echoed string
```
curl http://localhost:5000?my_string=MY_STRING
```
To get `index.html` from `html` directory:
```
curl http://<SERVER_IP>:5000/html/index.html
```
NOTE: any file added to html directory can be accessed using the filename like so:
```
curl http://<SERVER_IP>:5000/html/my-file.html
```

## Deploy Kubernetes cluster
`NOTE: This will create a VPC that includes subnets and and the cluster`

### Install pre-requisites
```
brew install awscli kubernetes-cli aws-iam-authenticator wget
```
### Run Terraform code
`NOTE: AWS credentials must be exist locally with permissions to create VPC, EC2 and EKS resources`
```
cd terraform
terraform init -upgrade
terraform plan
terraform apply  (enter yes)
```

## Basic Kubernetes configuration
```
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
wget -O v0.3.6.tar.gz https://codeload.github.com/kubernetes-sigs/metrics-server/tar.gz/v0.3.6 && tar -xzf v0.3.6.tar.gz
kubectl apply -f metrics-server-0.3.6/deploy/1.8+/
kubectl get deployment metrics-server -n kube-system
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
kubectl proxy
```

## Accessing the Dashboard
```
kubectl apply -f https://raw.githubusercontent.com/hashicorp/learn-terraform-provision-eks-cluster/master/kubernetes-dashboard-admin.rbac.yaml
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')
```
Now copy and past token from last step into the UI, UI can be accessed at [this link](http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

## Deploy app to Kubernetes


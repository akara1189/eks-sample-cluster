#/bin/bash

AWS_PROFILE=default

command_array=("aws --version" "kubectl version --client=true" "eksctl version")
for command in "${command_array[@]}"
do
  ${command}
done

#The above will crash the script if building has failed. If not, commands continue here.

#Creating node roles
node_role="AmazonEKSNodeRole"
aws iam create-role \
  --role-name ${node_role} \
  --assume-role-policy-document file://"trust_policy.json"

aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy \
  --role-name ${node_role}

aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly \
  --role-name ${node_role}

aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy \
  --role-name ${node_role}

#Create the cluster
eksctl create cluster -f ./cluster_config.yaml

#Create access entries for node provisioning
node_role_arn=$(aws iam get-role --role-name ${node_role} --query "Role.Arn" --output text)
aws eks create-access-entry \
  --cluster-name eks-test-cluster \
  --principal-arn ${node_role_arn} \
  --type EC2

aws eks associate-access-policy \
  --cluster-name eks-test-cluster \
  --principal-arn ${node_role_arn} \
  --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSAutoNodePolicy \
  --access-scope type=cluster

aws eks update-kubeconfig --name eks-test-cluster #Just to make sure we're in the right context.

kubectl apply -f ./node_class.yaml
kubectl apply -f ./node_pool.yaml
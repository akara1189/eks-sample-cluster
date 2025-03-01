#/bin/bash

command_array=("aws --version" "kubectl version --client=true" "eksctl version")
for command in "${command_array[@]}"
do
  ${command}
done
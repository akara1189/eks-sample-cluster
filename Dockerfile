FROM ubuntu

ARG AWS_CLI_REPO

ARG KUBECTL_VERSION

ARG EKSCTL_PLATFORM

WORKDIR /eks

RUN apt-get update && apt-get upgrade -y && apt-get install -y curl unzip

RUN curl ${AWS_CLI_REPO} -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install

RUN curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /bin/kubectl

RUN curl -LO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${EKSCTL_PLATFORM}.tar.gz" && tar -xzf eksctl_${EKSCTL_PLATFORM}.tar.gz && rm eksctl_${EKSCTL_PLATFORM}.tar.gz && mv eksctl /usr/local/bin

COPY configuration_files/* /eks/

COPY sample_app/* /eks/sample_app/

COPY default.config /root/.aws/credentials

#Not recommended for application containers but this is a tool container so it needs Shell access for scripts.
SHELL ["/bin/bash", "-c"] 

ENTRYPOINT "./test_script.sh"
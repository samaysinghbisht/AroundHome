# Hello World application deployment on EKS via Github Actions.

## Introduction

This application consists of a very basic Hello World Application, Dockerfile, Helm chart, Terraform to setup EKS, and Github Actions pipeline to deploy the changes to EKS cluster.

## Pre-requisites

Ensure the following are installed and properly configured:

1. Docker
2. Kubectl
3. AWS CLI
4. Terraform
5. HELM

## Steps to Deploy the App

Clone the repository by running below command:
```bash
git clone https://github.com/samaysinghbisht/AroundHome.git
```

### In Docker

Navigate to the "root" directory and execute the following commands:

```bash
docker build -t image-tag .
docker run -p 8080:80 image-tag
```

The application should now be accessible on `localhost:8080`.

### In Local Kubernetes

From the root directory, perform the following:

```bash
kubectl create namespace namespace-name
helm install hello-world hello-world-helm -n namespace-name
kubectl get all # Ensure all components are running
kubectl port-forward service/hello-world 8080:80
```

The application should now be accessible on `localhost:8080`.

### In EKS

To deploy the app on EKS, follow these steps:

1. **Setup EKS Cluster**

   Navigate to "terraform-config" and adjust `variables.tf` as needed.

   ```bash
   terraform init
   terraform fmt
   terraform validate
   terraform plan # Review the planned actions
   terraform apply # Execute the plan
   ```

2. **Update Kubernetes Context**

   Configure `kubectl` to use the new EKS context:

   ```bash
   aws eks update-kubeconfig --name cluster-name --region your-region --profile your-profile-name
   ```

3. **Deploy to EKS**
    * Manual Deployment
        From the root directory, deploy using Helm:

        ```bash
        kubectl create namespace namespace-name
        helm install hello-world hello-world -n namespace-name
        kubectl get all # Confirm all services are operational
        ```

        *Note:* If using a LoadBalancer service, wait for AWS to provision the endpoint and access the app via the provided URL.

    * Deployment via github actions pipeline:
        - Setup the following variables in your github repository's environment variables(secrets):
            | Secret Name             | Description                                                              |
            |-------------------------|--------------------------------------------------------------------------|
            | `DOCKER_USERNAME`       | Your Docker Hub username.                                                |
            | `DOCKER_PASSWORD`       | Your Docker Hub password or access token.                                |
            | `AWS_ACCESS_KEY_ID`     | Your AWS IAM access key ID.                                              |
            | `AWS_SECRET_ACCESS_KEY` | Your AWS IAM secret access key.                                          |
            | `AWS_REGION`            | The AWS region where your EKS cluster is located (e.g., `eu-central-1`). |
            | `CLUSTER_NAME`          | Name of your EKS cluster.                                                |

        - Make some changes to the applicaiton and push the changes to the repository.
        - Navigate to 'Actions' in Github repository to see the pipeline in action.
        - Wait for AWS to provision the endpoint and access the app via Loadbalancer URL.

## Deliverables

This project satisfies the following criteria:

- A small "hello-world" app containerized .

- CICD which will deploy the app to EKS.

- Terraform Code to setup the EKS cluster

## Additional Deliverables

- A helm Chart to setup the application easily.
- Images are being pushed to DockerHub instead of ECR, but that can be changed if required.

## Special Notes
- The ingress controller has not been configured in EKS; hence, the LoadBalancer URL will change if you delete and reinstall the app.
- Retrieve the new URL with `kubectl get svc -n namespace-name`.


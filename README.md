## This is a deployment solution to Rearc's "Quest" application

### Architecture:
 The app is packaged into a container, pushed into dockerhub registry then deploy on AWS ECS Fargate.
 An application load balancer is registered to the ECS Service with the service endpoint URL available to end-users.

![alt architecture](img/architecture.png)

### Prerequisites to deploy the stack:
 - an AWS account
 - Terraform CLI v1.2 or latest
 - AWS CLI v2.0 or lastest

### How to deploy:

 - Clone this repository and cd into root directory
 - `$ cd infra && terraform init` <br>
**Note**: Remote Backend has not been configured, so the state will be managed locally
 - `$ terraform workspace new <your-workpace-name>`
 - `$ terraform plan` (this will output the resources that are about to be deployed)
 - `$ terraform apply` <br>
    Look in console output for the URL endpoints for the application

### Endpoints Screenshots:

 - /
   ![alt index](img/index.png)
 - /docker
   ![alt docker](img/docker.png)
 - /secret_word
   ![alt secret_](img/secret_word.png)
 - /aws
   ![alt aws](img/aws.png) 

 - /loadbalanced
   ![alt lb](img/loadbalanced.png)
 - /tls
   **note**: TLS hasn't been configured yet (TODO)
   ![alt tls](img/tls.png)

### Improvements:

Given more time I would add a CI/CD pipeline using AWS CodePipeline, AWS Codebuild and AWS CodeDeploy <br>
to automate the deployment of this application
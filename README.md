# Summary

While exploring the documentation site for my employer at the time, I came across an interesting challenge one of the teams would give to prospective candidates. The challenge was to create a simple web application that displayed the IP address of the requestor. The candidate could use any language or framework they wanted. The only requirement was that the application had to be deployed AWS. To deploy the app, the candidate could use any tools they wanted including scripting directly against the AWS API. The only requirement was that the candidate had to provide the team with a script to clean up the resources created for the application.

For some, this challenge would be trivial but the idea behind the challenge was not to see how much a candidate knew about web applications and AWS. The idea was to see how the candidate approached the problem and how they solved it. I thought this was a great idea and decided to complete the challenge myself. For the web application, I chose to use Python and Flask. For the deployment, I chose to use Terraform and Ansible. In the next few sections, I will go more in-depth on the tools I chose and why I chose them.

## Tooling

### Python

I chose Python because it is a language I am familiar with and I chose the Flask framework because it is easy to get a simple web application up and running. I also chose Python because it is a language that is widely used in the industry and it is a language that I enjoy using.

### Terraform

I chose Terraform because it is a tool that is widely used in the industry. I chose Terraform over CloudFormation because I wanted to use a tool that was not specific to AWS. I wanted to use a tool that could be used to deploy to multiple cloud providers should the want arise. Additionally, Terraform makes it very easy to destroy the resources it creates. This is important because I wanted to make sure I could easily clean up the resources I created for the application as per the requirements of the challenge.

### Ansible

Terraform is an excellent tool for deploying and managing infrastructure but it is not a configuration management tool. For this reason, I chose to use Ansible to configure the EC2 instance that would host the application. Like Terraform, Ansible is also a tool that is widely used in the industry.

### NGINX

NGINX is a tool I chose to use to serve the application. I wanted to make sure the application could be served over HTTPS and NGINX makes it very easy to do this.

### Docker

Docker is not a tool I chose to use for this challenge but it is a tool I chose to use to make the application easier to run. with Docker I can easily run the application locally without having to install Python or any of the dependencies required by the application.

### Vagrant

Vagrant is a tool I chose to use to make it easier to test the Ansible configuration. With Vagrant, I can easily spin up a local VM and test the Ansible configuration against it before deploying the application to AWS.

## Deployment

The Terraform configuration for the application is located in the `deployment` directory along with the Ansible configuration in `server.yaml`. The Terraform configuration finds the latest Ubuntu 22.04 AMI, before it creates a Security Group and an EC2 instance. Once the instance is created, Terraform uses the `local-exec` provisioner to run the Ansible command needed to configure the instance. The Ansible configuration installs the required dependencies, copies the application files to the instance, and starts the application. To deploy the application, run the following commands:

```bash
cd deployment
terraform init
terraform plan
terraform apply
```
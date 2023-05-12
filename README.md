Table of Contents
=================
   * [Summary](#summary)
   * [Tooling](#tooling)
      * [Python](#python)
      * [Terraform](#terraform)
      * [Ansible](#ansible)
      * [NGINX](#nginx)
      * [Docker](#docker)
      * [Vagrant](#vagrant)
      * [Github Actions](#github-actions)
   * [Deploying the application](#deploying-the-application)
      * [Pre-requisites](#pre-requisites)
      * [Deploying the application to AWS](#deploying-the-application-to-aws)
      * [Deploying the application to Proxmox](#deploying-the-application-to-proxmox)
      * [Deploy the app to k8s](#deploy-the-app-to-k8s)

# Summary

While exploring the documentation site for my employer at the time, I came across an interesting challenge one of the teams would give to prospective candidates. The challenge was to create a simple web application that displayed the IP address of the requestor. The candidate could use any language or framework they wanted. The only requirement was that the application had to be deployed to AWS. To deploy the app, the candidate could use any tools they wanted including scripting directly against the AWS API. The only requirement was that the candidate had to provide the team with a script to clean up the resources created for the application.

For some, this challenge would be trivial but the idea behind the challenge was not to see how much a candidate knew about web applications and AWS. The idea was to see how the candidate approached the problem and how they solved it. I thought this was a great idea and decided to complete the challenge myself. For the web application, I chose to use Python and Flask. For the deployment, I chose to use Terraform and Ansible. In the next few sections, I will go more in-depth on the tools I chose and why I chose them.

## Tooling

### Python

I chose Python because it is a language I am familiar with and I chose the Flask framework because it is easy to get a simple web application up and running. I also chose Python because it is a language that is widely used in the industry and it is a language that I enjoy using.

### Terraform

I chose Terraform because it is a tool that is widely used in the industry. I chose Terraform over CloudFormation because I wanted to use a tool that was not specific to AWS. I wanted to use a tool that could be used to deploy to multiple cloud providers should the want arise. Additionally, Terraform makes it very easy to destroy the resources it creates. This is important because I wanted to make sure I could easily clean up the resources I created for the application as per the requirements of the challenge.

### Ansible

Terraform is an excellent tool for deploying and managing infrastructure but it is not a configuration management tool. For this reason, I chose to use Ansible to configure the EC2 instance that would host the application. Like Terraform, Ansible is also a tool that is widely used in the industry.

### NGINX

NGINX is a tool I chose to use to serve the application. I wanted to make sure the application could be served over HTTP/HTTPS and NGINX makes it very easy to do this.

### Docker

Docker is not a tool I chose to use for this challenge but it is a tool I chose to use to make the application easier to run. With Docker I can easily run the application locally without having to install Python or any of the dependencies required by the application.

### Vagrant

Vagrant is a tool I chose to use to make it easier to test the Ansible configuration. With Vagrant, I can easily spin up a local VM and test the Ansible configuration against it before deploying the application to AWS.

### Github Actions

Github Actions is a tool I chose to use to automate the testing of the application. With Github Actions, I can easily build and test the application every time I push a commit to the repository. It's also responsible for publishing the latest Docker image to Docker Hub.

## Deploying the application

### Pre-requisites

To deploy the application, you will need to have the following installed:

* [Terraform](https://www.terraform.io/downloads.html)
  * I recommend using [tfenv](https://github.com/tfutils/tfenv) to manage your Terraform versions
* [Python 3.11](https://www.python.org/downloads/) with [pip](https://pip.pypa.io/en/stable/installing/)
    * I recommend using [pyenv](https://github.com/pyenv/pyenv) to manage your Python versions
    * I also recommend you set up a [virtual environment](https://docs.python.org/3/tutorial/venv.html) for the application. pyenv has a [plugin](https://github.com/pyenv/pyenv-virtualenv) pyenv-virtualenv that makes this very easy.
* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
  * Ansible is listed as a dependency in the `requirements-dev.txt` file. You can install it by running `pip install -r requirements-dev.txt`

### Running the application locally

To run the application locally, you will need to install the dependencies listed in the `requirements.txt` file. You can do this by running `pip install -r requirements.txt`. Once the dependencies are installed, you can run the application by running `gunicorn src.main:app -w 2 --threads 2 -b 0.0.0.0:5001 --reload`. The application will be available at `http://localhost:5001`. You can also run the application using Docker by running `docker-compose up`. The application will then be available at `http://localhost:80` since it is served by NGINX.

### Deploying the application to AWS

To deploy the application to AWS we use a combination of Terraform and Ansible. The Terraform configuration is responsible for creating the EC2 instance that will host the application. It is also responsible for creating the security group that will allow access to the application. The Ansible configuration is responsible for configuring the EC2 instance to run the application. It is also responsible for configuring NGINX to serve the application. Here are the steps to deploy the application to AWS:

**Assumptions:**
* You are not using a Cloudflare tunnel to access the application *(all references to cloudflare within the Terraform configurations should be commented out)*
* As part of the Ansible configuration, applications files are copied over to the host rather than using `git`. This means the `git_enabled` variable within the `playbook.yaml` file should be set to `false`. The `cf_enabled` variable should also be set to `false` since we are not using Cloudflare.
* You have `make` installed

1. Ensure you have a valid AWS access key and secret key set as environment variables
2. Ensure you have an SSH key pair created in AWS
3. Update the `key_name` and `private_key` variables in the `variables.tf` file to match the name of the key pair you created in step 2 and the path to the private key on your local machine.
4. Update the `server_name` variable within the ansible playbook `deploy/ansible/playbook.yaml` to match the domain name you want to use for the application (use '127.0.0.1' if you don't have a domain name)
5. Run `make deploy-configure PROV=aws` to deploy the application to AWS
6. If you don't have make installed, you can run the following commands instead:

```bash
cd deploy/aws
terraform init
terraform plan
terraform apply

cd ../../ansible`
ansible-playbook -i inventory.ini playbook.yaml
```

To clean up the resources created by Terraform, you can run the following command:

```bash
# from the root of the project
make destroy-vm PROV=aws

# OR
cd deploy/aws
terraform destroy
```

### Deploy the application to Proxmox

To deploy the application to Proxmox, you will need to have a Proxmox cluster up and running. Once you have that then you can deploy the application with Terraform/Ansible. The Terraform configuration provided here is more for reference and personal use than anything else. It is not meant to be used as-is. It would need to be modified to suit your needs. It also requires that you have a Proxmox template (created using cloud-init) created for Ubuntu 22.04. If you need help with that then I've provided the Ansible playbook I used to create the template in the `deploy/ansible/proxmox` directory. Once you have a template created, you can deploy the application by running command similar to the one above but with the `PROV` variable set to `proxmox` instead of `aws`. Additionally, you will need to create a `proxmox/terraform.tfvars` file with all the required variables. You can use the `proxmox/terraform.tfvars.example` file as a reference.

### Deploy the app to k8s

To run the application in k8s, you will need to have a cluster up and running. I recommend using [kind](https://kind.sigs.k8s.io/docs/user/quick-start/) to create a local cluster. Once you have a cluster up and running, you can deploy the application by running the following command:

```bash
cd kubernetes
kubectl apply -f deployment.yaml
```

To access the application, you can use port-forwarding by running the following command:

```bash
kubectl port-forward service/ip-address-challenge-service 5001:5001
```

The application will then be available at `http://localhost:5001`.

To delete the application, you can run the following command:

```bash
kubectl delete -f deployment.yaml
```

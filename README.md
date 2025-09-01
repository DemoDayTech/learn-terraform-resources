# Learn Terraform Resources

Out of the box working version of the 'learn-terraform-resources' tutorial found at: https://developer.hashicorp.com/terraform/tutorials/configuration-language/resource

## Overview

In this tutorial, you will create an EC2 instance that runs a PHP web application. You will then create a security group to make the application publicly accessible.

In main.tf, a local ephemeral key file is created locally, which can be used to SSH into the EC2 instance. 
- chmod 400 "test-demo-key.pem"
- ssh -i "test-demo-key.pem" ec2-user@<ec2_public_dns>
- Once SSH'ed into the EC2, you can view /var/log/cloud-init-output.log to debug any errors with the init-script.sh

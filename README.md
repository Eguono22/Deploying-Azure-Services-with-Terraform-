# Deploying Azure Services with Terraform

This repository deploys a simple Azure web application stack with:

- Azure App Service (Linux Web App)
- Azure Database for MySQL Flexible Server

## Prerequisites

- Terraform 1.5+
- Azure CLI authenticated with `az login`

## Usage

1. Create a tfvars file from the example:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Update `terraform.tfvars` with a strong `mysql_admin_password`.

3. Initialize and deploy:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. After apply, use outputs to get the app URL and MySQL hostname:

   ```bash
   terraform output
   ```

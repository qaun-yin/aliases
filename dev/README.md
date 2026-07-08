# Development Tools

This directory contains resources for setting up development environments, including Terraform configurations for cloud infrastructure.

## Table of Contents

- [Terraform Configurations](#terraform-configurations)
- [Usage](#usage)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)

## Terraform Configurations

### dev-server

Terraform configuration for deploying a development server on AWS EC2 with Visual Studio Code access.

**Features:**

- AWS EC2 t2.micro instance
- Visual Studio Code Server installation
- ZeroTier network integration
- Pre-installed development tools

**Requirements:**

- AWS account with appropriate permissions
- AWS CLI configured with access keys
- Terraform installed
- ZeroTier installed locally
- SSH key pair

**Components:**

- **main.tf**: Main Terraform configuration with AWS provider, EC2 instance, security groups, and key pair
- **variables.tf**: Variable definitions
- **output.tf**: Output values including public IP
- **dev-server.md**: Detailed setup instructions

**Setup Process:**

1. Configure AWS CLI with your access keys
2. Initialize Terraform project
3. Apply Terraform configuration
4. Configure ZeroTier networking
5. Access Visual Studio Code via web browser

**Usage:**

```bash
# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply configuration
terraform apply

# Destroy resources when done
terraform destroy
```

## Usage

To use these development tools:

1. Ensure all requirements are met
2. Review the Terraform configuration files
3. Customize variables as needed
4. Initialize and apply the Terraform configuration
5. Follow the setup instructions in the documentation

## Examples

### Basic Terraform Workflow

```bash
# Navigate to the terraform directory
cd terraform/dev-server

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply

# Get the public IP
terraform output public_ip

# Destroy when finished
terraform destroy
```

### AWS CLI Configuration

```bash
# Configure AWS CLI
aws configure
# AWS Access Key ID [None]: YOUR_ACCESS_KEY
# AWS Secret Access Key [None]: YOUR_SECRET_KEY
# Default region name [None]: us-west-2
# Default output format [None]: json
```

## Troubleshooting

### Common Issues

1. **Terraform Initialization Errors**
   - Verify internet connectivity
   - Check AWS credentials
   - Ensure Terraform is properly installed

2. **AWS Permission Errors**
   - Verify IAM user permissions
   - Check AWS region availability
   - Confirm service limits

3. **ZeroTier Connection Issues**
   - Verify network ID
   - Check ZeroTier service status
   - Approve node in ZeroTier Central

### Getting Help

If you encounter issues not covered in this documentation:

1. Check the specific Terraform files for comments and documentation
2. Refer to the detailed setup instructions in dev-server.md
3. Consult official documentation for Terraform and AWS
4. Open an issue on GitHub with detailed information
5. Include error messages and system information

# Deploy Static Web Page using CloudFront and S3 Bucket

This repository provides an Infrastructure as Code (IaC) setup using Terraform and Terragrunt to manage an S3 bucket and CloudFront distribution with Route 53 integration. The configuration supports deploying a static website to AWS.

---

## Features

- **Terraform Module**: A reusable module for creating and managing AWS S3 buckets, CloudFront distributions, and associated policies.
- **Terragrunt**: Simplifies Terraform usage with DRY principles and remote state management.
- **AWS Integrations**:
  - S3 bucket with optional public access blocking and versioning.
  - CloudFront distribution for serving static content with SSL support via ACM.
  - Route 53 for domain name resolution.
- **GitHub Actions**: CI/CD pipeline for deploying static website updates to S3.

---

## Prerequisites

### Tools Required

- [Terraform](https://www.terraform.io/downloads.html)
- [Terragrunt](https://terragrunt.gruntwork.io/)
- [AWS CLI](https://aws.amazon.com/cli/)
- [GitHub CLI](https://cli.github.com/)

### AWS Resources Needed

- AWS Account with permissions to manage S3, CloudFront, ACM, and Route 53.
- A hosted zone in Route 53 for domain management.

---

## Repository Structure

```plaintext
.
├── terragrunt
│   ├── s3
│   │   └── terragrunt.hcl
│   ├── cloudfront
│   │   └── terragrunt.hcl
│   └── route53
│       └── terragrunt.hcl
├── modules
│   ├── s3
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   ├── cloudfront
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   └── route53
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md
├── workflows
│   └── deploy-to-s3.yml
└── README.md
```

---

## Usage

### Setting Up the Environment

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-repo.git
   cd your-repo
   ```

2. **Install Dependencies**
   Ensure Terraform, Terragrunt, and AWS CLI are installed and configured.

3. **Configure AWS Credentials**
   Use the AWS CLI to authenticate:
   ```bash
   aws configure
   ```

### Terraform Module

#### S3 Module xxx

The S3 module provisions a bucket with configurable settings, such as:
- Public access blocking.
- Website hosting configuration.
- Versioning support.

**Example Usage:**
```hcl
module "s3" {
  source        = "../modules/s3"
  bucket_name   = "example-bucket"
  force_destroy = true
  tags          = {
    Environment = "Production"
  }
}
```

#### CloudFront Module

The CloudFront module creates a distribution with an optional ACM certificate and origin access identity.

**Example Usage:**
```hcl
module "cloudfront" {
  source              = "../modules/cloudfront"
  website_endpoint    = module.s3.website_endpoint
  acm_certificate_arn = "arn:aws:acm:region:account:certificate/id"
  alternate_domain_names = ["example.com"]
}
```

#### Route 53 Module

The Route 53 module sets up DNS records for the CloudFront distribution.

**Example Usage:**
```hcl
module "route53" {
  source   = "../modules/route53"
  domain   = "example.com"
  zone_id  = "Z3M3LMPEXAMPLE"
  target   = module.cloudfront.cloudfront_domain_name
}
```

---

### Terragrunt

#### Folder Structure

Terragrunt configurations are organized by service:

- `terragrunt/s3/terragrunt.hcl`:
  ```hcl
  include "root" {
    path = find_in_parent_folders()
  }

  terraform {
    source = "../modules/s3"
  }

  inputs = {
    bucket_name   = "example-bucket"
    force_destroy = true
  }
  ```

- `terragrunt/cloudfront/terragrunt.hcl`:
  ```hcl
  include "root" {
    path = find_in_parent_folders()
  }

  terraform {
    source = "../modules/cloudfront"
  }

  inputs = {
    website_endpoint        = "example-bucket.s3-website-region.amazonaws.com"
    acm_certificate_arn     = "arn:aws:acm:region:account:certificate/id"
    alternate_domain_names  = ["example.com"]
  }
  ```

- `terragrunt/route53/terragrunt.hcl`:
  ```hcl
  include "root" {
    path = find_in_parent_folders()
  }

  terraform {
    source = "../modules/route53"
  }

  inputs = {
    domain   = "example.com"
    zone_id  = "Z3M3LMPEXAMPLE"
    target   = "example.cloudfront.net"
  }
  ```

#### Running Terragrunt

Navigate to the appropriate folder and run:
```bash
terragrunt apply
```

---

### GitHub Actions

#### CI/CD Workflow

A GitHub Actions workflow is included to deploy static website updates to the S3 bucket.

1. **Add Secrets**:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

2. **Trigger Deployment**:
   Push changes to the `main` branch to trigger the workflow.

**Workflow Configuration:**
```yaml
name: Deploy to S3

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v3
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1

    - name: Sync files to S3
      run: aws s3 sync ./path/to/static/website s3://your-s3-bucket-name --delete
```

---

## References

- [Terraform Documentation](https://registry.terraform.io/)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide/)
- [GitHub Actions](https://docs.github.com/en/actions)

---

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

# Nuvolar test

Task 1 contains the system document
Task 2 contains the terraform code for the specified task.

## AWS Setup

Install AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

In the .aws folder, set your default config:

```bash
[default]
aws_access_key_id = <access_key>
aws_secret_access_key = <secret_access_key>
region = eu-central-1
```
Export the newly created profile:
```bash
export AWS_PROFILE=default
```

## Usage

```python
terraform init

terraform plan

terraform apply
```

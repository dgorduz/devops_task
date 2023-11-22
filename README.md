# DevOps Task Project Structure
## Prerequisite
Jenkins Server:
- An already available Jenkins server.

AWS Account:

- Admin access to the AWS account.

User Permissions:

- The AWS user should have the following IAM permissions and then generate the Access Keys and store them securily in the Jenkins server:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeInstanceCreditSpecifications",
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeVpcs",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceTypes",
                "ec2:RunInstances",
                "ec2:DescribeImages",
                "ec2:TerminateInstances",
                "ec2:ModifyInstanceAttribute",
                "ec2:DeleteKeyPair",
                "ec2:DescribeKeyPairs",
                "ec2:ImportKeyPair"
            ],
            "Resource": "*"
        }
    ]
} 
```

## How to
- **Packer:**
  - Create a custom AWS Windows AMI with Packer through this command:
    ```bash
    packer build -var 'sys_pass=enter_custom_password' aws-windows-server.pkr.hcl
    ```

- **Jenkins + Terraform:**
  - Create a new Jenkins pipeline using this repo for Jenkinsfile retrieval and run a dry run for that pipeline: [devops_task Jenkinsfile](https://github.com/dgorduz/devops_task/tree/dev)
  - The pipeline is parametrized, requiring the following credentials on your Jenkins server:
    - `AWS_ACCESS_KEY_ID` (generated from a user created on your AWS account)
    - `AWS_SECRET_ACCESS_KEY` (generated from a user created on your AWS account)
    - `WIN_PASS` (the password used when creating the custom AWS Windows AMI with Packer)
  - There's a build parameter for the number of environments to create, `nr_vms` (default is 1).
  - Jenkins Pipeline Steps:
    1. Checkout
    2. Terraform init
    3. Terraform plan
    4. Terraform apply with parameters

- **Dotnet App:**
  - The app is available in this repo: [Blazor App Demo](https://github.com/dgorduz/blazor_app_demo/tree/dev)

- **Known Issues:**
  - Cannot start the Dotnet app automatically, as Terraform won't finish until Ctrl+C is pressed.
- **Current solution:** 
    - Manually start the app on the AWS Windows Server with the following command in PowerShell:
    ```powershell
    C:\Users\Administrator\blazor_app_demo\build_env.ps1
    ```
  - The app will be accessible on port `8080` inside and outside the network, that was whitelisted in the Windows Server.

## Achievement:
When new changes a done to the BlazorApp (dotnet app) the pipeline is triggered automatically and as a result a new environment is provisioned and ready to be used in about `3 min`.
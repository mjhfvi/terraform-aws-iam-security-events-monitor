# Security

## AWS iam user Access key

- build user with aws_access_key_id & aws_secret_access_key in
  "Identity and Access Management (IAM)" > "Users" > "Create User"
- use the file 'secret.tfvars' to set the access key & secret key for the project

## pre-commit-hook

- pre-commit install
- pre-commit run --all-files

use hooks to get password in the code
.talismanrc
.secrets.baseline

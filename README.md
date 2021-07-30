# terraform-cloudfront-bucket


## Deploy

### Terraform
```
terraform init
terraform plan  -var-file="terraform.tfvars"
terraform apply  -var-file="terraform.tfvars" -var "aws_profile=some_awscli_profile"
```

### Cloudfront Alias

1. Navigate to Cloudfront
2. Click `Edit` in Settings on the General Tab
3. Request Certificate
4. Add domain name
5. Follow the wizard.
6. Return to the Edit Tab
7. Add the domain name

## List of Permissions Needed

Incomplete List of Permissions Needed

- CloudFrontFullAccess

## TODO

- Test AWS Permissions
- Add Cache Invalidation
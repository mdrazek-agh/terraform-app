## Prerequisites

You need to have terraform installed as well as your Digital Ocean API token created  

## Running

1. To initialize the terraform run
>`terraform init`

2. Export DigitalOcean API key as environment variable
>`export TF_VARS_do_token="<DO_TOKEN_NAME>"`

3. To make a plan of infrastructure run 
>`terraform plan -out=infra.out`

4. To perform the deployment run 
>`terraform apply infra.out`  

## Editing

After you've made any changes to the files simply run steps 3. and 4. again  

## Cleanup

To destroy the infrastructure run 
>`terraform destroy`

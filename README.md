

# Terraform Registry Mirror

A set of scripts to create a mirror of terraform providers to work without official `registry.terraform.io`.

May be extremely useful for software engineers who work from Russian Federation or Republic of Belarus 
and being banned by [https://www.hashicorp.com/](HashiCorp).

```
 bin/ -
   |- core.sh
   |- mirror.sh
   |- updater.sh 
```

 `core.sh` - will download `terraform` binaries of specified platforms and placed to `mirror` directory.

  e.g.

    bin/core.sh terraform.json


 `mirror.sh` - will download `terraform providers` of specified platforms and versions and placed them to the `mirror` directory.
 
  e.g.
  
    bin/mirror.sh providers/aws.json

  
  `updater.sh` - will check new versions and add them the to providers file.
  
  e.g
  
    bin/updater.sh providers/aws.json

  Provider file has following format:

```json
{
  "provider": {
    "namespace": "hashicorp",
    "name": "aws",
    "versions": [
      "3.11.0",
      "3.12.0"
    ]
  }
}
```

  See more example in `providers` directory.

## Github actions

 - `updater.yaml` - will run `updater.sh` on all listed provider files and commit changes to the repository. Should be run manually.

 - `mirror.yaml`  - will run `core.sh` and `mirror.sh` on all listed provider files, prepare terraform mirror and deploy the to s3 bucket.
    Triggered by commit to `master` branch.

    Github secrets needed for deploying:
   
      - AWS_REGION
      - AWS_ACCESS_KEY
      - AWS_SECRET_KEY
      - S3_BUCKET_NAME
    
    Please fill free to rewrite `Deploy mirror to s3 bucket` step if you need to upload terraform mirror to smth else.


## Mirroring preparation

 - Create s3 bucket with public access and acl on.
 - Create CloudFront pointed to this bucket and provide ssl certificate (use AWS Certificate Manager or its own). 
   Terraform requires `https` address protocol.
 - Create CNAME dns record pointed to CloudFront address.

## Usage

Create `~/.terraformrc` file with the following content

```
provider_installation {
  network_mirror {
    url = "<https address of your mirror>"
  }
}
```

## Testing

Go to `example` directory and try

    terraform init

If terraform mirror has been created successfully, terraform will initialize sample project.


-------------------

Inspired by [https://github.com/straubt1/terraform-network-mirror](https://github.com/straubt1/terraform-network-mirrorhttps://github.com/straubt1/terraform-network-mirror).


      
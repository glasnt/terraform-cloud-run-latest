# Cloud Run Latest

Module to interrogate the Container Registry to get the sha of the `latest` image, to ensure Terraform can update a Cloud Run service. 

Supports only public/private setting, copy configurations into your own module to extend. 

## Usage: 

```
module "cloud_run_latest" {
  source = "./terraform-cloud-run-latest" #TODO(glasnt): update when published. 

  service_name = "myservice"
  image_name = "myimage"
  project = "myproject"
  public = false
}
```
# Cloud Run Latest

![For Demo Purposes Only](https://img.shields.io/static/v1?label=State&message=For%20Demo%20Purposes%20Only&color=red) [![No Maintenance Intended](http://unmaintained.tech/badge.svg)](http://unmaintained.tech/) 


Module to interrogate the Container Registry to get the sha of the `latest` image, to ensure Terraform can update a Cloud Run service. 

Supports only public/private setting, copy configurations into your own module to extend. 

## Example Usage

For a private service using an existing image. 

```
module "cloud_run_latest" {
  source  = "glasnt/cloud-run-latest/google"

  service_name = "myservice"
  image_name = "myimage"
  project = "myproject"
  public = false
}
```
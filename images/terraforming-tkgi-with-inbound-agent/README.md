## Terraform and TKGI CLI in a Docker Image packaged with Jenkins Inbound Agent

This image contains uuidgen, AWS, TKGI and Terraform CLIs and the [Jenkins inbound agent](https://github.com/jenkinsci/docker-inbound-agent).

For more information about Tanzu Kubernetes Grid Integrated Edition (TKGI) CLI, consult the product documentation [page](https://docs.pivotal.io/tkgi/1-10/cli/index.html).

### How to build your own image

```bash
docker build --build-arg api_token={tanzu-network-api-token} -t {prefix}/{image-name} .
```
> Replace `{tanzu-network-api-token}` with a valid VMware Tanzu Network account [API Token](https://network.pivotal.io/users/dashboard/edit-profile). Replace `{prefix}/{image-name}` with your your prefix and image that you'll use to source the image from your private container registry.

### How to source the pre-built image from Dockerhub

```bash
docker pull pacphi/terraforming-tkgi-with-inbound-agent
```

### How to run locally

```bash
docker run -it --rm pacphi/terraforming-tkgi-with-inbound-agent /bin/sh
```

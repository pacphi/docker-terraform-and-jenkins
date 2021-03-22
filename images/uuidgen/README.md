## Linux utility uuidgen in a Docker Image

This image contains Linux utilities, the most useful of which is **uuidgen**.
> Why am I building this? Hunches shoulders.

### How to build your own image

```bash
docker build -t {prefix}/{image-name} .
```
> Replace `{prefix}/{image-name}` with your your prefix and image that you'll use to source the image from your private container registry.

### How to source the pre-built image from Dockerhub

```bash
docker pull pacphi/uuidgen
```

### How to run locally

```bash
docker run -it --rm pacphi/uuidgen /bin/sh
```

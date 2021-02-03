# docker-terraform-and-jenkins

Fun with Docker, Terraform, Jenkins and Artifactory.

![Screenshot of create-gke-cluster pipeline](create-gke-cluster.png)
## Prerequisites

* Google Cloud
  * [Service Account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
  * 2x [VMs](https://cloud.google.com/compute/docs/quickstart-linux)
    * 1 VM with Jenkins and Docker
    * 1 VM with Artifactory
  * 2x [Storage buckets](https://cloud.google.com/storage/docs/creating-buckets)
    * 1 should be named `terraform-state` and be configured to vend items only to authorized accounts
    * 1 should be named `sa-credentials` and be configured to vend items only to authorized accounts
* Jenkins
  * [Installation](https://www.cloudbooklet.com/how-to-install-jenkins-on-ubuntu-20-04-with-nginx-and-ssl/)
  * Add plugins
    * // TODO
  * Configure plugins
    * // TODO
* Docker
  * [Installation](https://linuxize.com/post/how-to-install-and-use-docker-on-ubuntu-20-04/)
  * Images
    * [cloud-sdk](https://cloud.google.com/sdk/docs/downloads-docker)
    * [terraform](https://hub.docker.com/r/hashicorp/terraform/)
* Artifactory
  * [Installation](https://computingforgeeks.com/configure-jfrog-artifactory-behind-nginx-reverse-proxy-letsencrypt/)
  * Configure a [local Generic repo](https://www.jfrog.com/confluence/display/JFROG/Repository+Management#RepositoryManagement-LocalRepositories) named `terraform-state`

## Setup for GKE

### Sensitive configuration

Upload your sensitive configuration to a pre-configured Google Cloud storage buckets.

To create each bucket you could use the [cloud-sdk](https://cloud.google.com/sdk/docs/downloads-docker) Docker image or have directly [installed the SDK on your workstation](https://cloud.google.com/sdk/docs/install). (It's strongly recommended to append a unique suffix to each bucket name to avoid name collisions/conflicts).

```bash
gsutil mb -l {location} gs://terraform-vars-{suffix}
gsutil mb -l {location} gs://terraform-secrets-{suffix}
gsutil mb -l {location} gs://sa-credentials-{suffix}
```
> Replace `{location}` above with a [region](https://cloud.google.com/about/locations) (e.g., `us-west1`).  Also replace `{suffix}` with a unique string.

Then configure buckets for version control

```bash
gsutil versioning set on gs://terraform-vars-{suffix}
gsutil versioning set on gs://terraform-secrets-{suffix}
gsutil versioning set on gs://sa-credentials-{suffix}
```
> Replace `{suffix}` above with same string you defined when you created the bucket

Now let's upload a couple files.  Place yourself into the module directory.

```bash
cd terraform/clusters/gke
```

#### terraform.tfvars

Copy the sample [terraform.tfvars.sample](terraform/clusters/gke/terraform.tfvars.sample) to `terraform.tfvars`. (Amend the value for each key in the new file as required and make sure that the end of this file contains a single newline).

Upload the file

```bash
gsutil cp terraform.tfvars gs://terraform-vars-{suffix}/clusters/gke/terraform.tfvars
```
> Replace `{suffix}` above with same string you defined when you created the bucket

#### backend.tf

Copy the sample [backend.tf.sample](terraform/clusters/gke/backend.tf.sample) to `backend.tf`. (Amend the value for each key in the new file as required).
> It's unfortunate that we can't use variables, see this [issue](https://github.com/hashicorp/terraform/issues/13022).

Upload the file

```bash
gsutil cp backend.tf gs://terraform-vars-{suffix}/clusters/gke/backend.tf
```
> Replace `{suffix}` above with same string you defined when you created the bucket

#### gcp-service-account.json

You'll need to upload a copy of the [service account key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#iam-service-account-keys-create-gcloud) (in json format).  The file should be named `gcp-service-account.json`.

```bash
gsutil cp gcp-service-account.json gs://sa-credentials-{suffix}/gcp-service-account.json
```
> Replace `{suffix}` above with same string you defined when you created the bucket

### Jenkins

Login to the Jenkins instance via your favorite browser.

You'll need to create pipelines based upon [Jenkinsfile](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/) you will find in the [ci/gke](ci/gke) directory.

// TODO


## Setup for TKGI

### Sensitive configuration

Upload your sensitive configuration to a pre-configured Amazon S3 storage buckets.

To create each bucket you could use the [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-docker.html) Docker image or have directly [installed the CLI on your workstation](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html). (It's strongly recommended to append a unique suffix to each bucket name to avoid name collisions/conflicts).


```bash
aws s3 mb s3://terraform-vars-{suffix}
aws s3 mb s3://terraform-secrets-{suffix}
aws s3 mb s3://terraform-state-{suffix}
```
> Replace `{suffix}` with a unique string.

Then configure buckets for version control

```bash
aws s3api put-bucket-versioning --bucket terraform-vars-{suffix} --versioning-configuration Status=Enabled
aws s3api put-bucket-versioning --bucket terraform-secrets-{suffix} --versioning-configuration Status=Enabled
aws s3api put-bucket-versioning --bucket terraform-state-{suffix} --versioning-configuration Status=Enabled
```
> Replace `{suffix}` above with same string you defined when you created the bucket

Then configure buckets for server-side encryption

```bash
aws s3api put-bucket-encryption \
    --bucket terraform-vars-{suffix} \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

aws s3api put-bucket-encryption \
    --bucket terraform-secrets-{suffix} \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

aws s3api put-bucket-encryption \
    --bucket terraform-state-{suffix} \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
```

// TODO  Add bucket policy that allows for  authenticated IAM user to list and write bucket objects

Now let's upload a couple files.  Place yourself into the module directory.

```bash
cd terraform/clusters/tkgi
```

#### terraform.tfvars

Copy the sample [terraform.tfvars.sample](terraform/clusters/tkgi/terraform.tfvars.sample) to `terraform.tfvars`. (Amend the value for each key in the new file as required and make sure that the end of this file contains a single newline).

Upload the file

```bash
aws s3 cp terraform.tfvars s3://terraform-vars-{suffix}/clusters/tkgi/terraform.tfvars
```
> Replace `{suffix}` above with same string you defined when you created the bucket

#### backend.tf

Copy the sample [backend.tf.sample](terraform/clusters/tkgi/backend.tf.sample) to `backend.tf`. (Amend the value for each key in the new file as required).
> It's unfortunate that we can't use variables, see this [issue](https://github.com/hashicorp/terraform/issues/13022).

Upload the file

```bash
aws s3 cp backend.tf s3://terraform-vars-{suffix}/clusters/tkgi/backend.tf
```
> Replace `{suffix}` above with same string you defined when you created the bucket

### Jenkins

Login to the Jenkins instance via your favorite browser.

You'll need to create pipelines based upon [Jenkinsfile](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/) you will find in the [ci/tkgi](ci/tkgi) directory.

// TODO
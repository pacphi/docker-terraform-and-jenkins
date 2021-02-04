FROM alpine:3.12 as build

ARG api_token 

ENV TERRAFORM_VERSION=0.14.5 \
    TKGI_VERSION=1.10.0 \
    TKGI_PRODUCT_FILE_ID=875614 \
    PIVNET_VERSION=2.0.2 \
    TANZU_NETWORK_API_TOKEN=$api_token

RUN apk add --no-cache bash bc coreutils gawk git grep sed unzip wget && \
    apk del --purge && \
    wget https://github.com/pivotal-cf/pivnet-cli/releases/download/v${PIVNET_VERSION}/pivnet-linux-amd64-${PIVNET_VERSION} && \
    mv pivnet-linux-amd64-${PIVNET_VERSION} pivnet && \
    chmod +x pivnet && \
    mv pivnet /usr/local/bin && \
    pivnet login --api-token=${TANZU_NETWORK_API_TOKEN} && \
    pivnet download-product-files --product-slug='pivotal-container-service' --release-version="${TKGI_VERSION}" --product-file-id="${TKGI_PRODUCT_FILE_ID}" --accept-eula && \
    export FILENAME=$(find . -type f -name "pks*.*" -print | head -n 1) && \
    mv ${FILENAME} tkgi && \
    chmod +x tkgi && \
    mv tkgi /usr/local/bin && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin

FROM bash:5.1.4
LABEL author=cphillipson@vmware.com

RUN apk add --no-cache git && \
    apk del --purge

COPY --from=build /usr/local/bin/tkgi /usr/local/bin
COPY --from=build /usr/local/bin/terraform /usr/local/bin

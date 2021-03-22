FROM alpine:3.12 as build

ARG api_token 

ENV TERRAFORM_VERSION=0.14.8 \
    TKGI_VERSION=1.10.0 \
    TKGI_PRODUCT_FILE_ID=875614 \
    PIVNET_VERSION=3.0.1 \
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

FROM jenkins/inbound-agent:4.6-1-alpine
LABEL author=cphillipson@vmware.com

ENV GLIBC_VER=2.32-r0

USER root

# install glibc compatibility for alpine, thanks to https://stackoverflow.com/questions/60298619/awscli-version-2-on-alpine-linux
RUN apk --no-cache add \
        binutils \
        curl \
        git \
        util-linux \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples \
    && apk --no-cache del \
        binutils \
        curl \
    && rm glibc-${GLIBC_VER}.apk \
    && rm glibc-bin-${GLIBC_VER}.apk \
    && rm -rf /var/cache/apk/*

RUN apk add --no-cache git && \
    apk del --purge

COPY --from=build /usr/local/bin/tkgi /usr/local/bin
COPY --from=build /usr/local/bin/terraform /usr/local/bin

USER jenkins

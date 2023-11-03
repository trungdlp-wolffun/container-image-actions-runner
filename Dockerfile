ARG RUNNER_VERSION=2.311.0

FROM ghcr.io/actions/actions-runner:${RUNNER_VERSION}

ARG HELM_VERSION=3.12.0
ARG CLOUD_SDK_VERSION=430.0.0
ARG YQ_VERSION=4.33.3

ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
ENV YQ_VERSION=$YQ_VERSION
ARG BUILDARCH

USER root
ENV HOME=/root

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
  gettext-base \
  apt-transport-https \
  ca-certificates \
  gnupg \
  curl \
  jq \
  parallel \
  git \
  openssh-client \
  unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3008,DL4006
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
  tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
  apt-get update && apt-get install -y --no-install-recommends google-cloud-cli=${CLOUD_SDK_VERSION}-0 && \
  gcloud config set core/disable_usage_reporting true && \
  gcloud config set component_manager/disable_update_check true && \
  gcloud config set metrics/environment github_docker_image  \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN curl -Lo /tmp/helm.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-${BUILDARCH}.tar.gz && \
  tar -C /tmp -xf /tmp/helm.tar.gz && \
  mv /tmp/linux-${BUILDARCH}/helm /usr/local/bin/helm && \
  chmod +x /usr/local/bin/helm && rm -rf /tmp/helm*

RUN curl -Lo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_${BUILDARCH} && \
  chmod +x /usr/local/bin/yq && \
  yq --version


ENV HOME=/home/runner
USER runner

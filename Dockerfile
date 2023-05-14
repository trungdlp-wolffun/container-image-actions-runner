ARG RUNNER_VERSION=v2.304.0
ARG DISTRO=ubuntu-20.04
ARG REPOSITORY=actions-runner-dind

FROM summerwind/${REPOSITORY}:${RUNNER_VERSION}-${DISTRO}

ARG HELM_VERSION=3.12.0
ARG CLOUD_SDK_VERSION=430.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
ARG BUILDARCH

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
  gettext-base \
  apt-transport-https \
  ca-certificates \
  gnupg \
  curl

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
  tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
  apt-get update && apt-get install --no-install-recommends google-cloud-cli=${CLOUD_SDK_VERSION}-0 && \
  gcloud config set core/disable_usage_reporting true && \
  gcloud config set component_manager/disable_update_check true && \
  gcloud config set metrics/environment github_docker_image

RUN curl -Lo /tmp/helm.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-${BUILDARCH}.tar.gz && \
  tar -C /tmp -xf /tmp/helm.tar.gz && \
  mv /tmp/linux-${BUILDARCH}/helm /usr/local/bin/helm && \
  chmod +x /usr/local/bin/helm && rm -rf /tmp/helm*

USER runner

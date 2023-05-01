ARG RUNNER_VERSION DISTRO REPOSITORY

FROM summerwind/${REPOSITORY}:${RUNNER_VERSION}-${DISTRO}

USER root

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  gettext-base

USER runner

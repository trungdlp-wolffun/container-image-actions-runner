ARG RUNNER_VERSION DISTRO REPOSITORY

FROM summerwind/${REPOSITORY}:${RUNNER_VERSION}-${DISTRO}

WORKDIR /build-space

USER root

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  gettext-base

COPY ./runner-images/images/linux/scripts scripts
RUN chmod -R +x scripts
RUN export HELPER_SCRIPTS="./../helpers"
RUN ./scripts/installers/git.sh

USER runner

### Container image for GitHub Actions Runner


#### Build cmd
```sh
docker build . -t runner --build-arg DISTRO=ubuntu-20.04 --build-arg REPOSITORY=actions-runner --build-arg RUNNER_VERSION=v2.304.0
```
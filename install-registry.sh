#!/bin/bash
# Install the docker registry
if [[ ! -e distribution ]]; then
  git clone https://github.com/docker/distribution.git
fi
pushd distribution
rm -f cmd/registry/config.yml
cp -f ${path}config.yml cmd/registry/config.yml
rm -r Dockerfile
cp -f ${path}registry-dockerfile Dockerfile
docker build -t registry .
docker run -d -p 5000:5000 registry:latest
popd

#!/bin/bash
# Clone stashbot for a build example
git clone https://github.com/palantir/stashbot.git
chown -R vagrant:vagrant stashbot
# At this point we should be good to go so try to install stashabot
echo "Trying to install stashbot."
pushd stashbot
while [[ ! $(curl -u admin:admin -L http://localhost:7990/stash/projects | grep 'PROJECT_1') ]]; do
  sleep 20
done
while [[ ! $(atlas-package && atlas-install-plugin) ]]; do
  echo "Could not install stashbot so re-trying after sleep."
  sleep 20
done
popd

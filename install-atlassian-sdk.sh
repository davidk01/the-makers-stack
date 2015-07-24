#!/bin/bash
pushd /etc/yum.repos.d/
wget http://sdkrepo.atlassian.com/atlassian-sdk-stable.repo
yum -y -q clean all
yum -y -q updateinfo metadata
popd
yum -y -q install atlassian-plugin-sdk
# local atlassian mirror if atlassian-mirror exists
if [[ -e ${path}atlassian-mirror ]]; then
  replacement=$(cat ${path}atlassian-mirror)
  sed -i.bak "s#https://maven.atlassian.com/repository/public#${replacement}#g" /usr/share/atlassian-plugin-sdk-5.0.13/apache-maven-3.2.1/conf/settings.xml
fi
mkdir stash
pushd stash
tmux new -s stash -d
tmux send-keys -t stash 'atlas-run-standalone --product stash' Enter
popd
while true; do
  sleep 60
  tmux send-keys -t stash 'n' Enter
done

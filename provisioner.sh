#!/bin/bash
export path="/vagrant/"

# base repo mirror if there is a mirror file
yum -y -q install epel-release deltarpm curl wget git gpg
# Genearte key and disable ssl verify
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
su -l vagrant -c 'ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa'
git config --global http.sslVerify false
yum -y -q install docker
systemctl start docker
# Add the mirror certificate so that things work
if [[ -e ${path}docker-registry-mirror ]]; then
  echo "Adding registry mirror certs"
  registry="$(cat ${path}docker-registry-mirror)"
  openssl s_client -showcerts -connect ${registry}:443 < /dev/null > ca.crt
  mkdir -p /etc/docker/certs.d/${registry}
  cp ca.crt /etc/docker/certs.d/${registry}
fi

if [[ -e ${path}yum-mirror ]]; then
  echo "Setting up yum mirror for base"
  rm -rf /etc/yum.repos.d/CentOS-Base*
  cp -f ${path}yum-mirror /etc/yum.repos.d/CentOS-Base-Mirror.repo
  yum -q clean all
  yum -q updateinfo metadata
fi

# Copy Rakefile if it exists
if [[ -e /code/Rakefile ]]; then
  cp /code/Rakefile .
fi

# Development tools because we'll most likely need it
echo "Installing development tools"
yum -y -q groupinstall 'development tools'

# Registry stuff. Make the container and start the registry
echo "Installing docker registry"
nohup ${path}install-registry.sh 1> docker.out 2>&1 &

# Make it possible to install sysdig
rpm --import https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public 
curl -s -o /etc/yum.repos.d/draios.repo http://download.draios.com/stable/rpm/draios.repo

# Install openjdk because Java
echo "Installing openjdk"
yum -y -q install java-1.8.0-openjdk-headless java-1.8.0-openjdk-devel

# Install jenkins along with a bunch of plugins
echo "Installing jenkins"
nohup ${path}install-jenkins.sh 1> jenkins.out 2>&1 &
# Copy the job config updater to /usr/local/bin
cp ${path}job-config-updater.rb /usr/local/bin/

# Need curl, vim, strace, htop, etc.
echo "Installing libraries and tools"
yum install -y -q tmux vim java strace htop lsof bind-utils \
  patch libyaml-devel glibc-headers autoconf gcc-c++ glibc-devel patch \
  readline-devel zlib-devel libffi-devel openssl-devel automake libtool \
  bison sqlite-devel

# Install atlassian sdk
echo "Installing atlassian sdk"
nohup ${path}install-atlassian-sdk.sh 1> atlassian.out 2>&1 &

# Need RVM for various Ruby related things
echo "Installing ruby"
${path}install-ruby.sh
# Run the base URL fixer
# bash -l -c "ruby ${path}baseurl-fixer.rb"

# Install stashbot
nohup ${path}install-stashbot.sh 1> stashbot.out 2>&1 &

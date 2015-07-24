# the-makers-stack
Like the drink but better.

# Mirrors and Caches
Because initial startup can take some time if you are doing things from scratch it is helpful if you have local mirrors of various package repositories. One is the RPM repo and the other is the atlassian maven repo. For RPM packages if you have a local mirror of the base CentOS 7 packages then put the configuration in a text file called `yum-mirror` at the base of this repository, e.g.

```
[base-mirror]
name=CentOS-$releasever - Base
baseurl=http://mirror/CentOS/7/os/x86_64/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
```

For the atlassian maven mirror it is another file (`atlassian-mirror`) but this time it is just the URL, e.g.

```
http://mirror/artifactory/atlassian-maven-repo/
```

For further optimizations feel free to take a look at the provisioning script and make improvements as necessary.

# Sysdig
For figuring stuff out `sysdig` is pretty helpful but it requires restarting the VM, invoking `guest-additions.sh`, rebooting, and finally running `/lib/dkms/dkms_autoinstaller start`. Something to do with the kernel version and kernel headers.

# Components
Just running `vagrant up` gets you all the necessary pieces to get up and running with Jenkins and docker. The atlassian sdk is also installed so if you wanted to run any of the atlassian products alongside Jenkins then you can run `atlas-run-standalone --product [bamboo|stash|jira|etc.]` to get a development server of each of those products up and running. The services are not started automatically because it is a nice way during tutorial sessions to get people in the mood for running commands at the prompt by getting them to start bamboo and stash.

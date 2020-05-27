# Mandrel Packaging

This repo contains all the necessary scripts and tools to build [Mandrel](https://github.com/graalvm/mandrel).

## Requirements

* docker or podman or root access to a Fedora/RHEL VM
* ansible

## Description

**TLDR**:

``` bash
git clone https://github.com/mandrel/mandrel-packaging
cd mandrel-packaging
make
```

By default `make`:

1. Removes any containers named `mandrel-packaging`
2. Creates a new container named `mandrel-packaging` from image `fedora:32`
3. Sets up the container using the ansible playbook `ansible/playbook.yml`
4. Attaches to the `mandrel-packaging` container

## Customization and more advanced use

When developing there is no need to remove and reset `mandrel-packaging` all the time.
Instead we can use the following `Makefile` targets to control the container.

* `make setup-image` reruns the ansible playbook (useful for testing changes in the playbook or testing different configurations)
* `make run-image-attach` attaches to an existing `mandrel-packaging` container without performing any setup
* `make reuse-image` runs target `setup-image` followed by `run-image-attach`
* `make cp-script` copies `src/build.java` from the host to the container (using for testing changes in the build script)
* `make stop-image` stops `mandrel-packaging`, if running

### Copy local files to container

`make cp-script` provides an easy way to copy `src/build.java`, but one might want to transfer other files as well.
To achieve this `docker cp` can be used:

* Copy build script sources:
``` bash
docker cp ~/code/mandrel-packaging/src/build.java mandrel-packaging:/root
```

* Copy mandrel sources:
``` bash
docker cp ~/code/mandrel/. mandrel-packaging:/tmp/mandrel
```
  Note: This will copy everything (including .git), you might prefer copying only the edited modules/files, e.g.:
``` bash
docker cp ~/code/mandrel/substratevm/. mandrel-packaging:/tmp/mandrel/substratevm
```

* Copy artifacts to host
``` bash
docker cp mandrel-packaging:/tmp/mandrel/substratevm/mxbuild/dists/jdk11/svm.jar ./
```

### Using podman instead of docker

If you prefer using `podman` instead of `docker` do:

``` bash
export DOCKER=podman
make
```

### Set up a remote VM with:

Instead of using containers it's also possible to use Fedora/CentOS/RHEL VMs using: 

``` bash
ansible-playbook -i root@example.com, ansible/playbook.yml
```

### Using different configurations

The ansible playbook supports different configurations (found under `ansible/configurations`).
To use a different configuration than the default (e.g. `mandrel20.1-labsjdk`) issue:
``` bash
export PLAYBOOK_CONF=mandrel20.1-labsjdk
make
# or for VMs
ansible-playbook -i root@example.com, ansible/playbook.yml -e configuration=mandrel20.1-labsjdk
```

To create a new configuration just copy an existing one and edit the values to your needs.

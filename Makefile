.PHONY: default reuse-image boot-fedora-image setup-image stop-image run-image-attach run-image rm-image cp-script

SCRIPT_PATH ?= src/image.java
DOCKER ?= docker
IMAGE_NAME ?= mandrel-packaging
PLAYBOOK ?= ansible/playbook.yml
PLAYBOOK_CONF ?= mandrel20.1-openjdk

default: rm-image boot-fedora-image setup-image run-image-attach

reuse-image: setup-image run-image-attach

boot-fedora-image:
	$(DOCKER) run --name=$(IMAGE_NAME) -itd fedora:32

setup-image: run-image
	ansible-playbook -i $(IMAGE_NAME), -c $(DOCKER) $(PLAYBOOK) -e configuration=$(PLAYBOOK_CONF)

stop-image:
	$(DOCKER) stop $(IMAGE_NAME) || true

run-image-attach: stop-image
	$(DOCKER) start -ai $(IMAGE_NAME)

run-image:
	$(DOCKER) start $(IMAGE_NAME)

rm-image: stop-image
	$(DOCKER) rm $(IMAGE_NAME) || true

cp-script: run-image
	$(DOCKER) cp $(SCRIPT_PATH) $(IMAGE_NAME)

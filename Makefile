.PHONY: build-image run-image

SCRIPT_PATH ?= src/image.java

run-image-docker:
	docker rm $$(docker ps -aq --filter name=mandrel-packaging)
	docker run --name=mandrel-packaging -itd fedora:32
	ansible-playbook -i mandrel-packaging, -c docker ansible/playbook.yml
	docker start -ai mandrel-packaging

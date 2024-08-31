DOCKER_USER=greycubesgav
DOCKER_IMAGE_NAME=slackware-jose
DOCKER_IMAGE_VERSION=latest
DOCKER_PLATFORM=linux/amd64

docker-build-image:
	docker build --platform $(DOCKER_PLATFORM) --file Dockerfile --tag $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) .

docker-run-image:
	docker run --platform $(DOCKER_PLATFORM) --rm -it $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

docker-build-artifact:
	DOCKER_BUILDKIT=1 docker build --platform $(DOCKER_PLATFORM) --file Dockerfile --tag $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) --target artifact --output type=local,dest=./pkgs/ .

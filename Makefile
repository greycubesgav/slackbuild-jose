# DOCKER FROM Image Settings
DOCKER_USER=greycubesgav
DOCKER_BASE_IMAGE_NAME=slackware-docker-base
DOCKER_BASE_IMAGE_TAG=aclemons
DOCKER_BASE_IMAGE_VERSION=15.0
# Default Source Code Version
SOURCE_VERSION=12
SOURCE_BUILD_TAG=_$(DOCKER_BASE_IMAGE_VERSION)_GG
# DOCKER TAG Image Settings
DOCKER_TARGET_IMAGE_NAME=slackbuild-jose
DOCKER_TARGET_TAG=?
DOCKER_PLATFORM=linux/amd64
# Add NOCACHE='--no-cache' to force a rebuild
NOCACHE=

# Build the package against slackware-current (libcrypto.so.3) and tag the package appropriately
docker-image-build-aclemons-12-current:
	$(MAKE) docker-image-build SOURCE_VERSION=12 DOCKER_BASE_IMAGE_VERSION='current'

docker-image-build-aclemons-14-current:
	$(MAKE) docker-image-build SOURCE_VERSION=14 DOCKER_BASE_IMAGE_VERSION='current'

# Build the package against slackware-v15 (libcrypto.so.1.1) and tag the package appropriately
docker-image-build-aclemons-12-15.0:
	$(MAKE) docker-image-build SOURCE_VERSION=12 DOCKER_BASE_IMAGE_VERSION='15.0'

docker-image-build-aclemons-14-15.0:
	$(MAKE) docker-image-build SOURCE_VERSION=14 DOCKER_BASE_IMAGE_VERSION='15.0'

# Build the package using the variables set in the Makefile
docker-image-build:
	$(eval DOCKER_FULL_BASE_IMAGE_NAME=$(DOCKER_USER)/$(DOCKER_BASE_IMAGE_NAME):$(DOCKER_BASE_IMAGE_TAG)-$(DOCKER_BASE_IMAGE_VERSION))
	$(eval DOCKER_FULL_TARGET_IMAGE_NAME=$(DOCKER_USER)/$(DOCKER_TARGET_IMAGE_NAME):v$(SOURCE_VERSION)-$(DOCKER_BASE_IMAGE_VERSION))
	@echo "Building $(DOCKER_FULL_TARGET_IMAGE_NAME) against $(DOCKER_FULL_BASE_IMAGE_NAME)"
	docker build --platform $(DOCKER_PLATFORM) --file Dockerfile \
		$(NOCACHE) \
		--build-arg DOCKER_FULL_BASE_IMAGE_NAME="$(DOCKER_FULL_BASE_IMAGE_NAME)" \
		--build-arg TAG='_$(DOCKER_BASE_IMAGE_VERSION)_GG' \
		--build-arg VERSION=$(SOURCE_VERSION) \
		--tag $(DOCKER_FULL_TARGET_IMAGE_NAME) .

#	docker build --platform $(DOCKER_PLATFORM) --file Dockerfile --tag $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) .
docker-run-image:
	docker run --platform $(DOCKER_PLATFORM) --rm -it $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

# -------------------------------------------------------------------------------------------------------
#  Package Extraction
# -------------------------------------------------------------------------------------------------------

docker-artifact-build-aclemons-12-current:
	$(MAKE) docker-artifact-build SOURCE_VERSION=12 DOCKER_BASE_IMAGE_VERSION='current'

docker-artifact-build-aclemons-14-current:
	$(MAKE) docker-artifact-build SOURCE_VERSION=14 DOCKER_BASE_IMAGE_VERSION='current'

docker-artifact-build-aclemons-12-15.0:
	$(MAKE) docker-artifact-build SOURCE_VERSION=12 DOCKER_BASE_IMAGE_VERSION='15.0'

docker-artifact-build-aclemons-14-15.0:
	$(MAKE) docker-artifact-build SOURCE_VERSION=14 DOCKER_BASE_IMAGE_VERSION='15.0'

docker-artifact-build:
	$(eval DOCKER_FULL_BASE_IMAGE_NAME=$(DOCKER_USER)/$(DOCKER_BASE_IMAGE_NAME):$(DOCKER_BASE_IMAGE_TAG)-$(DOCKER_BASE_IMAGE_VERSION))
	$(eval DOCKER_FULL_TARGET_IMAGE_NAME=$(DOCKER_USER)/$(DOCKER_TARGET_IMAGE_NAME):v$(SOURCE_VERSION)-$(DOCKER_BASE_IMAGE_VERSION))
	@echo "Extracting artifact from $(DOCKER_FULL_TARGET_IMAGE_NAME) to ./pkgs/"
	DOCKER_BUILDKIT=1 docker build --platform $(DOCKER_PLATFORM) --file Dockerfile \
		$(NOCACHE) \
		--build-arg DOCKER_FULL_BASE_IMAGE_NAME="$(DOCKER_FULL_BASE_IMAGE_NAME)" \
		--build-arg TAG='_$(DOCKER_BASE_IMAGE_VERSION)_GG' \
		--build-arg VERSION=$(SOURCE_VERSION) \
		--target artifact --output type=local,dest=./pkgs/ .

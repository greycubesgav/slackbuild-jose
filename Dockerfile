ARG DOCKER_FULL_BASE_IMAGE_NAME=greycubesgav/slackware-docker-base:aclemons-current
FROM ${DOCKER_FULL_BASE_IMAGE_NAME} AS builder

ARG TAG='_SL-CUR_GG' VERSION=14 BUILD=1

# Copy over the build files
COPY src/jose/jose-${VERSION}.tar.xz LICENSE src/jose/jose.info src/jose/jose.SlackBuild src/jose/README src/jose/slack-desc /root/build/
WORKDIR /root/build/
# Update the jose.info file to match the version we're building
RUN sed -i "s|VERSION=.*|VERSION=\"${VERSION}\"|" jose.info && export MD5SUM=$(md5sum jose-${VERSION}.tar.xz | cut -d ' ' -f 1) && sed -i "s|_MD5SUM_|${MD5SUM}|" jose.info
# Build the package
RUN VERSION="$VERSION" TAG="$TAG" BUILD="$BUILD" ./jose.SlackBuild
RUN installpkg /tmp/jose-${VERSION}*.tgz
RUN jose alg

# #ENTRYPOINT [ "bash" ]

# Create a clean image with only the artifact
FROM scratch AS artifact
COPY --from=builder /tmp/jose-*.tgz .
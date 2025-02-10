ARG DOCKER_FULL_BASE_IMAGE_NAME=greycubesgav/slackware-docker-base:aclemons-current
FROM ${DOCKER_FULL_BASE_IMAGE_NAME} AS builder

ARG TAG='_SL-CUR_GG' VERSION=14 BUILD=1

# Build JQ - from local repo sources
# - Required for the *building* of jose
#RUN wget --no-check-certificate  'https://slackbuilds.org/slackbuilds/15.0/system/jq.tar.gz'
#RUN wget --no-check-certificate 'https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-1.7.1.tar.gz'
#COPY src/jq* /root/jq/
#WORKDIR /root/jq
#RUN ./jq.SlackBuild
#RUN installpkg /tmp/jq-*.tgz

## Install the dependancies binaries for the buildhttp://www.slackware.com/~alien/slackbuilds/jq/pkg64/current/
#WORKDIR /root/jq/
#RUN wget --no-check-certificate http://www.slackware.com/~alien/slackbuilds/jq/pkg64/15.0/jq-1.6-x86_64-1alien.txz && \
#wget --no-check-certificate http://www.slackware.com/~alien/slackbuilds/jq/pkg64/15.0/jq-1.6-x86_64-1alien.txz.md5 && \
#md5sum -c jq-1.6-x86_64-1alien.txz.md5
#RUN upgradepkg --install-new --reinstall jq-1.6-x86_64-1alien.txz

# Set our prepended build artifact tag
#ENV TAG='_SL-CUR_GG'

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
FROM greycubesgav/slackware-docker-base:aclemons-current AS builder

# Build JQ - from local repo sources
# - Required for the *building* of jose and clevis
#RUN wget --no-check-certificate  'https://slackbuilds.org/slackbuilds/15.0/system/jq.tar.gz'
#RUN wget --no-check-certificate 'https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-1.7.1.tar.gz'
COPY src/jq* /root/jq/
WORKDIR /root/jq
RUN ./jq.SlackBuild
RUN installpkg /tmp/jq-*.tgz

## Install the dependancies binaries for the build
#WORKDIR /root/jq/
#RUN wget --no-check-certificate http://www.slackware.com/~alien/slackbuilds/jq/pkg64/15.0/jq-1.6-x86_64-1alien.txz && \
#wget --no-check-certificate http://www.slackware.com/~alien/slackbuilds/jq/pkg64/15.0/jq-1.6-x86_64-1alien.txz.md5 && \
#md5sum -c jq-1.6-x86_64-1alien.txz.md5
#RUN upgradepkg --install-new --reinstall jq-1.6-x86_64-1alien.txz

# Copy over the build files
COPY LICENSE jose.info jose.SlackBuild README slack-desc /root/build/

# Set our prepended build artifact tag
ENV TAG='_SL-CUR_GG'

# Grab the source and check the md5
WORKDIR /root/build/
RUN wget --no-check-certificate $(sed -n 's/DOWNLOAD="\(.*\)"/\1/p' jose.info)
RUN export pkgname=$(grep 'DOWNLOAD=' jose.info| sed 's|.*/||;s|"||g') \
&& export pkgmd5sum=$(sed -n 's/MD5SUM="\(.*\)"/\1/p' jose.info) \
&& echo "$pkgmd5sum  $pkgname" > "${pkgname}.md5" \
&& md5sum -c "${pkgname}.md5"

# Build the package
RUN ./jose.SlackBuild
RUN installpkg /tmp/jose-*.tgz
RUN jose alg

# #ENTRYPOINT [ "bash" ]

# Create a clean image with only the artifact
#FROM scratch AS artifact
#COPY --from=builder /tmp/jose*.tgz .
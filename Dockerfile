FROM greycubesgav/slackware-docker-base:latest AS builder

# Install the dependancies binaries for the build
WORKDIR /root/jq/
RUN wget --no-check-certificate http://www.slackware.com/~alien/slackbuilds/jq/pkg64/15.0/jq-1.6-x86_64-1alien.txz && \
wget --no-check-certificate http://www.slackware.com/~alien/slackbuilds/jq/pkg64/15.0/jq-1.6-x86_64-1alien.txz.md5 && \
md5sum -c jq-1.6-x86_64-1alien.txz.md5

RUN upgradepkg --install-new --reinstall jq-1.6-x86_64-1alien.txz

# Copy over the build files
COPY LICENSE jose.info jose.SlackBuild README slack-desc /root/build/

# Set our prepended build artifact tag
ENV TAG='_GG'

# Grab the source and check the md5
WORKDIR /root/build/
RUN wget --no-check-certificate $(sed -n 's/DOWNLOAD="\(.*\)"/\1/p' jose.info)
RUN export pkgname=$(grep 'DOWNLOAD=' jose.info| sed 's|.*/||;s|"||g') \
&& export pkgmd5sum=$(sed -n 's/MD5SUM="\(.*\)"/\1/p' jose.info) \
&& echo "$pkgmd5sum  $pkgname" > "${pkgname}.md5" \
&& md5sum -c "${pkgname}.md5"

# Build the package
RUN ./jose.SlackBuild

#ENTRYPOINT [ "bash" ]

# Create a clean image with only the artifact
FROM scratch AS artifact
COPY --from=builder /tmp/jose*.tgz .
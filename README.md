# slackbuild_jose
Slackware Builds script to build a slackware package of the jose library and cmd tool, require by clevis.


## Application Description
Jose is a command line utility for performing various tasks on JSON
Object Signing and Encryption (JOSE) objects. Jose provides a full
crypto stack including key generation, signing and encryption.

## Docker Based Build Instructions

The following instructions show how to build this package using the included Dockerfile.

Docker needs to be installed and running before running the make command.

The final artifact will be copied to a new ./pkgs directory

```bash
# Clone the git repo
git clone https://github.com/greycubesgav/slackbuild-jose
cd slackbuild-jose
make docker-build-artifact
# Slackware package will be created in ./pkgs
```

## Manual Build Instructions Under Slackware

The following instructions show how to build the package locally under Slackware.

```bash
# Clone the git repo
git clone https://github.com/greycubesgav/slackbuild-jose
cd slackbuild-jose
# Grab the url from the .info file and download it
wget $(sed -n 's/DOWNLOAD="\(.*\)"/\1/p' jose.info)
./jose.SlackBuild
# Slackware package will be created in /tmp
```

## Install instructions

Once the package is built, it can be installed with

```bash
upgradepkg --install-new --reinstall /tmp/jose-12-x86_64-1_GG.tgz
```
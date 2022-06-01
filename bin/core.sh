#!/bin/sh

TERRAFORM_RELEASES="https://releases.hashicorp.com/terraform"

PLATFORMS="linux_amd64 darwin_amd64"
MIRROR_PATH=./mirror

CORE_JSON=$1

if [ ! -f "$CORE_JSON" ]; then
  echo "File $CORE_JSON not found"
  exit 1
fi

download_core()
{
  VERSION=$1

  for platform in $PLATFORMS; do
    filename="terraform_${VERSION}_${platform}.zip"
    url="${TERRAFORM_RELEASES}/${VERSION}/${filename}"

    echo
    echo -n "Downloading Terraform Core Version: ${VERSION} [{platform}] ..."
    curl -s -Lo "${MIRROR_PATH}/${filename}" "${url}"
    echo " done."
  done
}


VERSIONS=$(cat $CORE_JSON | jq -r '.core[]')


for version in $VERSIONS; do
  download_core $version
done
#!/bin/sh

PLATFORMS="linux_amd64 darwin_amd64"
MIRROR_PATH=./mirror

PROVIDER_JSON=$1

if [ ! -f "$PROVIDER_JSON" ]; then
  echo "File $PROVIDER_JSON not found"
  exit 1
fi


download_provider()
{
  NAMESPACE=$1
  NAME=$2
  VERSION=$3

  echo "Downloading Terraform Provider ${NAMESPACE}/${NAME}:${VERSION}"
  cat > main.tf << EOF
terraform {
  required_providers {
    ${NAME} = {
      source  = "${NAMESPACE}/${NAME}"
      version = "${VERSION}"
    }
  }
}
EOF

  for platform in $PLATFORMS; do
    terraform providers mirror -platform=${platform} ./
  done

  rm main.tf
}

NAMESPACE=$(cat $PROVIDER_JSON | jq -r '.provider.namespace')
NAME=$(cat $PROVIDER_JSON | jq -r '.provider.name')
VERSIONS=$(cat $PROVIDER_JSON | jq -r '.provider.versions[]')


cd ${MIRROR_PATH}

for version in $VERSIONS; do
    download_provider $NAMESPACE $NAME $version
done

cd -
#!/bin/sh

TERRAFORM_REGISTRY="https://registry.terraform.io/v1/providers"

PROVIDER_JSON=$1

if [ ! -f "$PROVIDER_JSON" ]; then
  echo File $PROVIDER_JSON does not exists
  exit 1
fi

NAMESPACE=$(cat $PROVIDER_JSON | jq -r '.provider.namespace')
NAME=$(cat $PROVIDER_JSON | jq -r '.provider.name')


MINVER=$(cat $PROVIDER_JSON | jq -r '.provider.versions | min ' )


echo "Generate version json files for namespace: $NAMESPACE, provider: $NAME"

v=$(curl -s "${TERRAFORM_REGISTRY}/${NAMESPACE}/${NAME}/versions" -q | jq -r "[ .versions[].version | select( . >= \"$MINVER\")] | sort | reverse")

cat > $PROVIDER_JSON << EOF
{
  "provider": {
    "namespace": "${NAMESPACE}",
    "name": "${NAME}",
    "versions": ${v}
  }
}
EOF

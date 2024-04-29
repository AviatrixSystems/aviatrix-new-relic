#!/usr/bin/env bash

url="$1"
token="$2"

curl -s -X 'GET' \
  'https://'$url'/metrics-api/v1/gateways?format=json' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer '$token | jq '. | to_entries |  map_values(.value + {id: .key}) '

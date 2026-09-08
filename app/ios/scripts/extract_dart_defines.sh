#!/bin/bash

set -euo pipefail

output_file="${SRCROOT}/Flutter/DartDefines.xcconfig"

{
  echo "APP_ID=com.example.app"
  echo "APP_ID_SUFFIX="
  echo "APP_NAME=Flutter Template"
} >"${output_file}"

decode_base64() {
  echo "$1" | base64 --decode
}

IFS=',' read -r -a define_items <<<"${DART_DEFINES:-}"

for encoded_item in "${define_items[@]}"; do
  [[ -z "${encoded_item}" ]] && continue

  item="$(decode_base64 "${encoded_item}")"
  case "${item}" in
    APP_ID=* | APP_ID_SUFFIX=* | APP_NAME=*)
      echo "${item}" >>"${output_file}"
      ;;
  esac
done

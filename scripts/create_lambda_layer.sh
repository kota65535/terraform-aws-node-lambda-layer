#!/usr/bin/env bash
set -eu -o pipefail
set -x
export LC_ALL=C

# echo to stderr
eecho() { echo "$@" 1>&2; }

usage() {
  cat <<EOF
Usage:
  bash $(basename "$0") <nodejs-version> <package-json-file> <output-file>
Description:
  Create lambda layer zip file according to the requirements file.
Requirements:
  docker, realpath, zip
Arguments:
  nodejs-version    : Node.js version
  package-json-file : Path of pip requirements file
  output-file       : Output file path
EOF
}

# Check number of arguments
if [[ $# -ne 3 ]]; then
  usage && exit 1
fi

NODEJS_VERSION=$1
PACKAGE_JSON=$2
OUTPUT_FILE=$3

PACKAGE_LOCK_JSON="$(dirname "${PACKAGE_JSON}")/package-lock.json"

if [[ ! -f ${PACKAGE_JSON} || ! -f ${PACKAGE_LOCK_JSON} ]]; then
  eecho "[ERROR] package.json or package-lock.json not found in '${PACKAGE_JSON_DIR}'."
  exit 1
fi
# Ensure the directory exists
mkdir -p "$(dirname "${OUTPUT_FILE}")"

PACKAGE_JSON="$(realpath "${PACKAGE_JSON}")"
PACKAGE_LOCK_JSON="$(realpath "${PACKAGE_LOCK_JSON}")"
OUTPUT_FILE="$(realpath "$(dirname "${OUTPUT_FILE}")")/$(basename "${OUTPUT_FILE}")"
DEST_DIR="$(mktemp -d)"

(
  cd "${DEST_DIR}"
  mkdir -p nodejs

  # Run npm ci command inside the official node docker image
  docker run --rm -u "${UID}:${UID}" -v "${DEST_DIR}/nodejs:/work" -w /work -v "${PACKAGE_JSON}:/work/package.json" -v "${PACKAGE_LOCK_JSON}:/work/package-lock.json" "node:${NODEJS_VERSION}" npm ci --cache /tmp/.npm >&2

  zip -r "${OUTPUT_FILE}" .
)

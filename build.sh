#!/usr/bin/env bash

set -euo pipefail

target=${1:-amd64}
image_name=${IMAGE_NAME:-kali}
bindir=${HOME}/.local/bin

echo "build ${image_name} ${target} ..."

if [[ "$1" == "arm" ]]; then
    docker build --pull --platform linux/arm/v7 --tag ${image_name}:arm --build-arg IMAGE_NAME=${image_name} --file Dockerfile-arm .
elif [[ "$1" == "arm64" ]]; then
    docker build --pull --platform linux/arm64 --tag ${image_name}:arm64 --build-arg IMAGE_NAME=${image_name} --file Dockerfile-arm .
elif [[ "$1" == "crypto" ]]; then
    docker build --pull --tag ${image_name}:crypto --build-arg IMAGE_NAME=${image_name} --file Dockerfile-crypto .
elif [[ "$1" == "amd64" ]]; then
    docker build --pull --tag ${image_name} --build-arg IMAGE_NAME=${image_name} .
elif [[ "$1" == "all" ]]; then
    export IMAGE_NAME=${image_name}
    $0
    $0 crypto
    $0 arm
    $0 arm64
elif [[ "$1" != "install" ]]; then
    echo 2>&1 "Unknown target: ${target}"
    exit 2
fi


mkdir -p ${bindir}

env IMAGE_NAME=${image_name} envsubst '$IMAGE_NAME' < run.sh > ${bindir}/${image_name}
chmod a+x ${bindir}/${image_name}
touch -r run.sh ${bindir}/${image_name}

ln -sf ${image_name} ${bindir}/${image_name}-attach
ln -sf ${image_name} ${bindir}/${image_name}-arm
ln -sf ${image_name} ${bindir}/${image_name}-arm64
ln -sf ${image_name} ${bindir}/${image_name}-crypto

if [[ "$(which ${image_name}-attach)" != "$(realpath -s ${bindir}/${image_name}-attach)" ]]; then
    echo "You should add ${bindir} to your PATH in order to easily run the containers."
else
    echo "Launch scripts have been installed into ${bindir}"
fi

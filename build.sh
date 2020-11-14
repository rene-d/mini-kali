#!/usr/bin/env bash

set -euo pipefail

image_name=${IMAGE_NAME:-kali}
bindir=${HOME}/.local/bin


do_install()
{
    local run_sh="$(dirname $BASH_SOURCE)/run.sh"

    mkdir -p "${bindir}"

    env IMAGE_NAME=${image_name} envsubst '$IMAGE_NAME' < "${run_sh}" > "${bindir}/${image_name}"
    chmod a+x "${bindir}/${image_name}"
    touch -r "${run_sh}" "${bindir}/${image_name}"

    ln -sf ${image_name} ${bindir}/${image_name}-attach
    ln -sf ${image_name} ${bindir}/${image_name}-arm
    ln -sf ${image_name} ${bindir}/${image_name}-arm64
    ln -sf ${image_name} ${bindir}/${image_name}-crypto

    if [[ "$(which ""${image_name}-attach"")" != "$(realpath -s ""${bindir}/${image_name}-attach"")" ]]; then
        echo "You should add « ${bindir} » to your PATH in order to easily run the containers."
    else
        echo "Launch scripts have been installed into « ${bindir} »"
    fi
}


do_build()
{
    local target="$1"

    echo "build ${image_name} ${target} ..."

    if [[ "$target" == "arm" ]]; then
        docker build \
                --pull \
                --platform linux/arm/v7 \
                --tag ${image_name}:arm \
                --build-arg IMAGE_NAME=${image_name} \
                --file Dockerfile-arm \
                .

    elif [[ "$target" == "arm64" ]]; then
        docker build \
                --pull \
                --platform linux/arm64 \
                --tag ${image_name}:arm64 \
                --build-arg IMAGE_NAME=${image_name} \
                --file Dockerfile-arm \
                .

    elif [[ "$target" == "crypto" ]]; then
        docker build \
                --pull \
                --tag ${image_name}:crypto \
                --build-arg IMAGE_NAME=${image_name} \
                --file Dockerfile-crypto \
                .

    elif [[ "$target" == "amd64" ]]; then
        docker build \
                --pull \
                --tag ${image_name} \
                --build-arg IMAGE_NAME=${image_name} \
                .

    elif [[ "$target" == "all" ]]; then
        do_build amd64
        do_build arm
        do_build arm64
        do_build crypto

    elif [[ "$target" != "install" ]]; then
        echo 2>&1 "Unknown target: ${target}"
        exit 2
    fi

    do_install
}


usage()
{
    echo "Usage: $0 [-n <IMAGE_NAME>] [-p <BINDIR>]" 1>&2; exit 1;
}


while getopts ":n:p:" o; do
    case "${o}" in
        n)
            image_name=${OPTARG}
            ;;
        p)
            bindir=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${image_name}" ] || [ -z "${bindir}" ]; then
    usage
fi


#  target
if [ $# -eq 0 ]; then
    do_build amd64
else
    while [ $# -ne 0 ]; do
        do_build $1
        shift
    done
fi

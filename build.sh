#!/usr/bin/env bash

set -xeuo pipefail

image_name=${IMAGE_NAME:-kali}
bindir=${HOME}/.local/bin

case "$(uname -m)" in
    x86_64) my_arch=amd64 ;;
    arm64 | aarch64 | armv8 | armv9) my_arch=arm64 ;;
    armhf | armv7l | armv7 | armv6) my_arch=arm ;;
    *) my_arch= ;;
esac


do_install()
{
    local run_sh="$(dirname $BASH_SOURCE)/run.sh"

    mkdir -p "${bindir}"

    env IMAGE_NAME=${image_name} envsubst '$IMAGE_NAME' < "${run_sh}" > "${bindir}/${image_name}"
    chmod a+x "${bindir}/${image_name}"
    touch -r "${run_sh}" "${bindir}/${image_name}"

    ln -sf ${image_name} "${bindir}/${image_name}-attach"

    for tag in $(docker image ls --format {{.Tag}} --filter reference=${image_name}); do
        ln -sf ${image_name} "${bindir}/${image_name}-${tag}"
        echo "symlink ${bindir}/${image_name}-${tag}"
    done

    if [[ "$(/usr/bin/which ""${image_name}-attach"")" != "$(realpath -s ""${bindir}/${image_name}-attach"")" ]]; then
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
                --tag ${image_name}:amd64 \
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
    echo "Usage: $0 [-n <IMAGE_NAME>] [-p <BINDIR>] [-i]" 1>&2; exit 1;
}

install_only=
while getopts ":n:p:i" o; do
    case "${o}" in
        n)
            image_name=${OPTARG}
            ;;
        p)
            bindir=${OPTARG}
            ;;
        i)
            install_only=1
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

# install only
if [[ "$install_only" ]]; then
    do_install
    exit
fi

# build
if [ $# -eq 0 ]; then
    # current arch
    if [[ -z "${my_arch}" ]]; then
        echo >&2 "Unsupported arch: $(uname -m)"
        exit 2
    fi
    do_build ${my_arch}
else
    while [ $# -ne 0 ]; do
        do_build $1
        shift
    done
fi

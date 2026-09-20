#!/usr/bin/env bash
#
# Build the mini-kali image (linux/arm64) and install the launch scripts.
#

set -Eeuo pipefail

image_name=${IMAGE_NAME:-kali}
bindir=${HOME}/.local/bin


do_install()
{
    local run_sh="$(dirname $BASH_SOURCE)/run.sh"

    mkdir -p "${bindir}"

    # the image name is hardcoded in run.sh, patch it while installing
    sed -e "s/^image_name=kali\$/image_name=${image_name}/" "${run_sh}" > "${bindir}/${image_name}"
    chmod a+x "${bindir}/${image_name}"
    touch -r "${run_sh}" "${bindir}/${image_name}"

    ln -sf ${image_name} "${bindir}/${image_name}-attach"

    # realpath -s is not portable (BSD/macOS), just look at the PATH itself
    case ":${PATH}:" in
        *":${bindir}:"*)
            echo "Launch scripts have been installed into « ${bindir} »" ;;
        *)
            echo "You should add « ${bindir} » to your PATH in order to easily run the containers." ;;
    esac
}


do_build()
{
    echo "build ${image_name} ..."

    docker build \
            --pull \
            --platform linux/arm64 \
            --tag ${image_name} \
            --build-arg IMAGE_NAME=${image_name} \
            "$(dirname $BASH_SOURCE)"

    do_install
}


usage()
{
    echo "Usage: $0 [-n <IMAGE_NAME>] [-p <BINDIR>] [-i]" 1>&2
    echo "    -n   image name (default: ${image_name})" 1>&2
    echo "    -p   where to install the launch scripts (default: ${bindir})" 1>&2
    echo "    -i   install the launch scripts only, do not build" 1>&2
    exit 1
}

install_only=
while getopts ":n:p:i" o; do
    case "${o}" in
        n) image_name=${OPTARG} ;;
        p) bindir=${OPTARG} ;;
        i) install_only=1 ;;
        *) usage ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${image_name}" ] || [ -z "${bindir}" ] || [ $# -ne 0 ]; then
    usage
fi

if [[ "$install_only" ]]; then
    do_install
else
    do_build
fi

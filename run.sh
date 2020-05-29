#!/usr/bin/env bash

progname=$(basename "$0")

# run the native container (amd64/i386)
function run()
{
    exec docker run --rm -ti --label ${IMAGE_NAME} --hostname ${IMAGE_NAME} -v "$PWD":/${IMAGE_NAME} --cap-add=SYS_PTRACE ${IMAGE_NAME} $*
}

# run the arm/v7 container
function arm()
{
    exec docker run --rm -ti --label ${IMAGE_NAME} --hostname ${IMAGE_NAME} -v "$PWD":/${IMAGE_NAME} --cap-add=SYS_PTRACE -e flavor=arm ${IMAGE_NAME}:arm $*
}

# run the arm64 container
function arm64()
{
    exec docker run --rm -ti --label ${IMAGE_NAME} --hostname ${IMAGE_NAME} -v "$PWD":/${IMAGE_NAME} --cap-add=SYS_PTRACE -e flavor=arm64 ${IMAGE_NAME}:arm64 $*
}

# run the crypto/SageMath container
function crypto()
{
    exec docker run --rm -ti --label ${IMAGE_NAME} --hostname ${IMAGE_NAME} -v "$PWD":/${IMAGE_NAME} -e flavor=crypto ${IMAGE_NAME}:crypto $*
}

# attach to a running container
function attach()
{
    if [[ "$1" == "-h" ]]; then
        echo "Usage: $progname [-h | list | <n>]"
        exit
    fi

    if [[ "$1" == "list" ]]; then
        docker container ls  --filter 'label=${IMAGE_NAME}' --format '{{.ID}}\t{{.Status}}\t{{.Image}}\t{{.Command}}'
        exit
    fi

    declare -a ids

    ids=($(docker container ls --format '{{.ID}}' --filter 'label=${IMAGE_NAME}'))
    nb=${#ids[@]}

    if [ "${nb}" -eq 1 ]; then
        n=0
    elif [[ "$1" == "" ]]; then
        echo "${nb} containers are running, please choose one"
        exit
    else
        n=$(($1))
        if [ $n -lt 0 -o $n -ge $nb ]; then
            echo "Invalid container number ($n), should be 0 ≤ n < ${nb}"
            exit
        fi
    fi

    exec docker exec -ti -e instance=$n ${ids[$n]} bash
}


if [[ "$progname" =~ ^.*\-attach$ ]]; then
    attach $*
elif [[ "$progname" =~ ^.*\-arm$ ]]; then
    arm $*
elif [[ "$progname" =~ ^.*\-arm64$ ]]; then
    arm64 $*
elif [[ "$progname" =~ ^.*\-crypto$ ]]; then
    crypto $*
else
    run $*
fi

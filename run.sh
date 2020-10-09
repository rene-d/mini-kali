#!/usr/bin/env bash

progname=$(basename "$BASH_SOURCE")
image_name=${IMAGE_NAME}


# find the first free container id
function find_name()
{
    declare -a names
    local free_name
    local i

    names=($(docker container ls --format '{{.Names}}' --filter "label=${image_name}"))
    i=0
    while true; do
        i=$((i + 1))
        free_name=${image_name}_${i}
        for name in ${names[*]}; do
            if [[ $name == ${free_name} ]]; then
                free_name=
                break
            fi
        done
        if [[ ${free_name} != "" ]]; then
            break
        fi
    done

    echo ${free_name}
}


# run the native container (amd64/i386)
# run the arm/v7 container
# run the arm64 container
# run the crypto/SageMath container
function run()
{
    local name=$(find_name)
    local flavor=$1
    local tag=${flavor:-latest}
    shift

    exec docker run --rm -ti \
            --name ${name} \
            --label ${image_name} \
            --hostname ${image_name} \
            -v "$PWD":/${image_name} \
            --cap-add=SYS_PTRACE \
            -e flavor=${flavor} \
            ${image_name}:${tag} $*
}


# attach to a running container
function attach()
{
    if [[ "$1" == "-h" ]]; then
        echo "Usage: $progname [-h | list | <n>]"
        exit
    fi

    if [[ "$1" == "list" ]]; then
        docker container ls  --filter "label=${image_name}" --format '{{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Command}}'
        exit
    fi

    local n=$1
    declare -a ids

    ids=($(docker container ls --format '{{.ID}}' --filter "label=${image_name}" --filter "name=${image_name}_${n}"))

    if [[ ${#ids[@]} != 1 ]]; then
        echo "Invalid container number ($n), available ones are:"
        attach list
    else
        local instance=$(docker container ls --format '{{.Names}}' --filter "id=${ids[0]}")
        instance=${instance##${image_name}_}

        exec docker exec -ti -e instance=${instance} ${ids[0]} bash
    fi
}


if [[ "$progname" =~ ^.*\-attach$ ]]; then
    attach $*
else
    shopt -s extglob  # rtfm before whining
    run ${progname##${image_name}?(-)} $*
fi

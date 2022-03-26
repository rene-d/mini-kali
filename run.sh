#!/usr/bin/env bash

set -Eeuo pipefail

progname=$(basename "${BASH_SOURCE[0]}")
image_name=dgse

# find the first free container id
find_name()
{
    local free_name
    local i
    declare -a names=($(docker container ls --format {{.Names}} --filter label=${image_name}))

    i=0
    while true; do
        i=$((i + 1))
        free_name=${image_name}_${i}
        if [[ ${#names[*]} == 0 ]]; then break; fi
        for name in ${names[@]}; do
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


# run the amd64/i386 container
# run the arm/v7 container
# run the arm64 container
# run the crypto/SageMath container
run()
{
    local interactive=$1
    local tag=${2-}
    local name=$(find_name)
    local opt_docker
    shift 2

    if [[ -z "${tag}" ]]; then
        case "$(uname -m)" in
            x86_64) tag=amd64 ;;
            aarch64|arm64) tag=arm64 ;;
            *) echo >&2 "Unsupported arch: $(uname -m)"; exit 2 ;;
        esac
    fi

    # for now, sagemath image is only available for linux/amd64
    local ptf=linux/${tag}
    if [[ "${tag}" == "crypto" ]]; then
        ptf=linux/amd64
    fi

    if [[ $interactive ]]; then
        opt_docker="-ti"
    else
        opt_docker="-d --entrypoint /bin/sleep"
        echo "Starting container ${name} ..."
        set -- inf
    fi

    exec docker run --rm \
        ${opt_docker} \
            -v $HOME/.vscode-server:/root/.vscode-server \
            --platform ${ptf} \
            --name ${name} \
            --label ${image_name} \
            --hostname ${image_name} \
            -v $PWD:/${image_name} \
            --cap-add=SYS_PTRACE \
            -e flavor=${tag} \
            ${image_name}:${tag} $*
}


# attach to a running container
attach()
{
    local opt_count
    local n

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                echo "Usage: $progname [-h | list | <n>]"
                exit ;;
            list)
                docker container ls  --filter "label=${image_name}" --format '{{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Command}}'
                exit ;;
            count) opt_count=1 ;;
            [0-9]*) n=$1 ;;
        esac
        shift
    done

    declare -a ids=($(docker container ls --format '{{.ID}}' --filter "label=${image_name}" --filter "name=${image_name}_${n}"))

    if [[ $opt_count ]]; then
        echo ${#ids[@]}
        return 0
    fi

    if [[ ${#ids[@]} != 1 ]]; then
        echo "Invalid container number ($n), available ones are:"
        attach list
    else
        local instance=$(docker container ls --format '{{.Names}}' --filter "id=${ids[0]}")
        instance=${instance##${image_name}_}

        exec docker exec -ti -e instance=${instance} ${ids[0]} bash
    fi
}


# dgse -> attach au 1er conteneur dispo
if [[ $# -eq 0 ]] && [[ $(attach count) -gt 0 ]]; then
    attach
    exit
fi

shopt -s extglob  # rtfm before whining
tag=${progname##${image_name}?(-)}

while [[ $# -gt 0 ]]; do
    case $1 in
        start)
            shift
            run "" "${tag-}" $*
            exit
            ;;
        *) break ;;
    esac
    shift
done

run 1 "${tag-}" $*

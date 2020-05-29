#! /usr/bin/env bash

IMAGENAME=${IMAGENAME:-kali}

function link()
{
    local src="$1"
    local dst="$2"

    [ -f "$dst" ] && rm "$dst"

    ln "$src" "$dst" || cp -p "$src" "$dst"
}

if [[ "$1" == "arm" ]]; then
    docker buildx build --pull --platform linux/arm/v7 -t ${IMAGENAME}:arm --load --build-arg IMAGENAME=${IMAGENAME} .
elif [[ "$1" == "arm64" ]]; then
    docker buildx build --pull --platform linux/arm64 -t ${IMAGENAME}:arm64 --load --build-arg IMAGENAME=${IMAGENAME} .
elif [[ "$1" == "crypto" ]]; then
    docker build --pull --tag ${IMAGENAME}:crypto -f Dockerfile-crypto .
else
    docker build --pull --tag ${IMAGENAME} .
fi

if [ -d $HOME/.local/bin ]; then
    link run.sh $HOME/.local/bin/${IMAGENAME}
    link run.sh $HOME/.local/bin/${IMAGENAME}-arm
    link run.sh $HOME/.local/bin/${IMAGENAME}-arm64
    link run.sh $HOME/.local/bin/${IMAGENAME}-attach
    link run.sh $HOME/.local/bin/${IMAGENAME}-crypto
else
    echo "You should add an alias to your .bashrc/.zshrc in order to run the container"
fi

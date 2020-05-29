#! /usr/bin/env bash

IMAGE_NAME=${IMAGE_NAME:-kali}

if [[ "$1" == "arm" ]]; then
    docker buildx build --pull --platform linux/arm/v7 -t ${IMAGE_NAME}:arm --load --build-arg IMAGE_NAME=${IMAGE_NAME} .
elif [[ "$1" == "arm64" ]]; then
    docker buildx build --pull --platform linux/arm64 -t ${IMAGE_NAME}:arm64 --load --build-arg IMAGE_NAME=${IMAGE_NAME} .
elif [[ "$1" == "crypto" ]]; then
    docker build --pull --tag ${IMAGE_NAME}:crypto -f Dockerfile-crypto .
else
    docker build --pull --tag ${IMAGE_NAME} .
fi

if [ -d $HOME/.local/bin ]; then
    env IMAGE_NAME=${IMAGE_NAME} envsubst '$IMAGE_NAME' < run.sh > $HOME/.local/bin/${IMAGE_NAME}
    chmod a+x $HOME/.local/bin/${IMAGE_NAME}
    touch -r run.sh $HOME/.local/bin/${IMAGE_NAME}

    ln -sf ${IMAGE_NAME} $HOME/.local/bin/${IMAGE_NAME}-attach
    ln -sf ${IMAGE_NAME} $HOME/.local/bin/${IMAGE_NAME}-arm
    ln -sf ${IMAGE_NAME} $HOME/.local/bin/${IMAGE_NAME}-arm64
    ln -sf ${IMAGE_NAME} $HOME/.local/bin/${IMAGE_NAME}-crypto
else
    echo "You should add an alias to your .bashrc/.zshrc in order to run the container"
fi

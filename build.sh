#! /usr/bin/env bash

docker build --pull --tag mini-kali .

if [ -d $HOME/.local/bin ]; then
    printf '#!/bin/sh\ndocker run --rm -ti --hostname thug -v "$PWD":/thug --cap-add=SYS_PTRACE mini-kali $*\n' > $HOME/.local/bin/thug
    chmod a+x $HOME/.local/bin/thug
else
    echo "You should add an alias to your .bashrc/.zshrc in order to run the container"
fi

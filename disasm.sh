#!/usr/bin/env bash

set -eo pipefail

if [[ "$1" =~ "64" ]]; then
    arch="amd64"
else
    arch="i386"
fi

cat | tr -c -d '0-9A-Fa-f' | xxd -r -p > /tmp/obj.bin

if [ -x /usr/local/bin/disasm ]; then
    disasm -c $arch < /tmp/obj.bin
else
    [[ "$arch" == "amd64" ]] && arch="i386:x86-64"
    objdump -b binary -m $arch -M intel -D /tmp/obj.bin | grep -B0 -A999
fi
rm -f /tmp/obj.bin

#!/usr/bin/env bash

set -eo pipefail

if [[ "$1" =~ "64" ]]; then
    arch=-m64
    arch2=i386:x86-64
else
    arch=-m32
    arch2=i386
fi

printf ".intel_syntax noprefix\n_main:\n" > /tmp/asm.s
cat >> /tmp/asm.s

gcc $arch -c /tmp/asm.s -o /tmp/obj.o

objdump -m $arch2 -z -M intel -d /tmp/obj.o | grep _main -B0 -A999
rm -f /tmp/asm.s /tmp/obj.o

#!/usr/bin/env bash
#
# Assemble the instructions read on stdin and show the resulting opcodes.
# Usage: asm.sh [32]      (default: aarch64, "32" for arm 32-bit)
#

set -eo pipefail

if [[ "$1" =~ "32" ]]; then
    prefix=arm-linux-gnueabihf-
else
    prefix=
fi

printf "_main:\n" > /tmp/asm.s
cat >> /tmp/asm.s

${prefix}as /tmp/asm.s -o /tmp/obj.o

${prefix}objdump -z -d /tmp/obj.o | grep _main -B0 -A999
rm -f /tmp/asm.s /tmp/obj.o

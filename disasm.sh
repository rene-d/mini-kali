#!/usr/bin/env bash
#
# Disassemble the hexadecimal opcodes read on stdin.
#
# Usage: disasm.sh [32] [w]
#   32   arm 32-bit instead of aarch64
#   w    the input is made of 32-bit instruction words, as objdump prints them
#        (they are byte-swapped); without it, the input is a byte dump, in
#        memory order
#

set -eo pipefail

prefix=
arch=aarch64
word=

for arg; do
    case "$arg" in
        32) prefix=arm-linux-gnueabihf- ; arch=arm ;;
        w | word) word=1 ;;
    esac
done

hex=$(cat | tr -c -d '0-9A-Fa-f')

if [[ $word ]]; then
    hex=$(echo "$hex" | fold -w8 | sed -E 's/(..)(..)(..)(..)/\4\3\2\1/' | tr -d '\n')
fi

echo "$hex" | xxd -r -p > /tmp/obj.bin

${prefix}objdump -b binary -m $arch -D /tmp/obj.bin
rm -f /tmp/obj.bin

#!/usr/bin/env bash

inst_dot()
{
    [ ! -f $HOME/.$1 ] && cat $1 >> $HOME/.$1
}

inst_dot bash_aliases
inst_dot vimrc
inst_dot gdbinit

mkdir -p $HOME/.local/bin

inst_bin()
{
    for i; do
        [ -f $HOME/.local/bin/$i ] && continue
        cp -p $i $HOME/.local/bin
    done

}

inst_bin disasm.sh asm.sh rootme_ssh *-wrapper

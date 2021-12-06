#alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias ff='find -name'
alias gg='git grep -n'

if [[ -z "${flavor}" ]]; then
    suffixe=""
else
    suffixe=" \[\033[2m\]${flavor}\[\033[0m\] "
fi

if [[ "$(uname -m)" = "x86_64" ]]; then
    PS1="\[\033[01;32m\]\u\[\033[00m\]:\[\033[36m\]\w\[\033[00m\]${suffixe}\$ "
else
    PS1="\[\033[01;32m\]\u\[\033[00m\]:\[\033[35m\]\w\[\033[00m\]${suffixe}\$ "
fi

if [[ -n "$instance" ]]; then
    PS1="\[\033[01;33m\]#${instance}\[\033[0m\] "$PS1
fi

alias gdb-init='gdb -x /opt/tools/Gdbinit/gdbinit'
alias gdb-gef='/usr/bin/gdb -x /opt/tools/gef/gef.py -q'
alias gdb-pwndbg='/usr/bin/gdb -x /opt/tools/pwndbg/gdbinit.py -q'
alias gdb-peda='/usr/bin/gdb -x /opt/tools/peda/peda.py -q'

alias gdb="gdb -q"
alias gef="gdb-gef"
alias pwndbg='gdb-pwndbg'
alias peda="gdb-peda"

export EDITOR=vim
# export LANG=en_US.UTF-8
# export LC_CTYPE=C.UTF-8
if [[ $(tty) != "/dev/pts/0" ]]; then
    echo -e "I am on tty \033[01;33m$(tty)\033[0m"
fi

alias ssh=ssh-wrapper
alias scp=scp-wrapper

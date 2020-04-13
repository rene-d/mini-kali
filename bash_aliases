#alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'

PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[36m\]\w\[\033[00m\]\$ '

alias gdb-init='gdb -x /opt/tools/Gdbinit/gdbinit'
alias gdb-gef='/usr/bin/gdb -x /opt/tools/gef/gef.py -q'
alias gdb-pwndbg='/usr/bin/gdb -x /opt/tools/pwndbg/gdbinit.py -q'
alias gdb-peda='/usr/bin/gdb -x /opt/tools/peda/peda.py -q'

alias gdb="gdb -q"
alias gef="gdb-gef"
alias pwndbg='gdb-pwndbg'
alias peda="gdb-peda"

export EDITOR=vim
export LANG=en_US.UTF-8
export LC_CTYPE=C.UTF-8
[ $(tty) != "/dev/pts/0" ] && echo -e "I am on tty \033[01;33m$(tty)\033[0m"

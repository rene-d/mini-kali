#!/usr/bin/env bash

if [[ $EUID != 0 ]]; then
    if [ -x /usr/bin/sudo ] ; then
        exec sudo $0
    else
        echo "Run this script as root"
        exit 2
    fi
fi

apt-get update
apt-get upgrade -y
apt-get install -y --no-install-recommends build-essential file patch bzip2 xz-utils curl wget bash git openssh-client procps netbase dirmngr gnupg libssl-dev
apt-get install -y gdb gdbserver strace vim upx python3-dev poppler-utils ruby netcat bsdmainutils sshpass gawk bash-completion

# only in Kali distrib
apt-get install -y radare2 || true

# get last version of pip
curl -sL https://bootstrap.pypa.io/get-pip.py | python3 -

# the tools
mkdir -p /opt/tools

# http://docs.pwntools.com/  (+ ROPgadget)
pip3 --no-cache-dir install --upgrade pwntools

# gdb extensions
git clone --depth 1 https://github.com/longld/peda.git /opt/tools/peda
git clone --depth 1 https://github.com/hugsy/gef.git /opt/tools/gef
git clone --depth 1 https://github.com/gdbinit/Gdbinit /opt/tools/Gdbinit
git clone --depth 1 https://github.com/pwndbg/pwndbg /opt/tools/pwndbg

# other tools
git clone --depth 1 https://github.com/slimm609/checksec.sh /opt/tools/checksec.sh
ln -rsf /opt/tools/checksec.sh/checksec /usr/local/bin/checksec

# ropper, pyasn1, PIL, pycrypto
pip3 install --no-cache-dir --upgrade ropper pyasn1 bitarray pycrypto

# villoc: Visualization of heap operations.
git clone --depth 1 https://github.com/wapiflapi/villoc.git /opt/tools/villoc
ln -rsf /opt/tools/villoc/villoc.py /usr/local/bin/villoc


if [ "$(uname -m)" = "x86_64" ] ; then

    pip3 install --no-cache-dir --upgrade Pillow

    apt-get install -y binwalk ltrace libc6-i386 gcc-multilib g++-multilib john foremost sqlmap

    # zsteg: https://github.com/zed-0xff/zsteg
    gem install zsteg

    # http://angr.io
    pip3 install --no-cache-dir --upgrade angr

    # https://blog.didierstevens.com/programs/pdf-tools/
    curl -sL http://didierstevens.com/files/software/pdf-parser_V0_7_4.zip | funzip > /usr/local/bin/pdf-parser.py
    chmod a+x /usr/local/bin/pdf-parser.py

else
    apt-get install -y python3-pil
fi


apt-get autoremove -y
apt-get clean

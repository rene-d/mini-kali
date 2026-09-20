#!/usr/bin/env bash
#
# Install the mini-kali toolset on a Debian/Kali arm64 host (no Docker).
# The package list mirrors the one of the Dockerfile.
#

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

# base system and build toolchain
apt-get install -y --no-install-recommends \
    bash bash-completion bsdmainutils build-essential bzip2 cmake curl dirmngr file \
    git gawk gnupg htop netbase openssh-client patch pkg-config procps \
    python3-dev python3-pip python3-setuptools sshpass unzip vim wget xxd xz-utils

# debug, disassembly and reverse engineering
apt-get install -y gdb gdb-multiarch gdbserver strace ltrace checksec upx-ucl
apt-get install -y --no-install-recommends \
    binutils-arm-linux-gnueabihf binwalk hexedit \
    python3-capstone python3-keystone-engine python3-ropgadget

# only in the Kali repositories
apt-get install -y radare2 ropper || true

# forensics, steganography and password cracking
apt-get install -y foremost john sqlmap steghide stegsnow zbar-tools
apt-get install -y --no-install-recommends imagemagick libimage-exiftool-perl poppler-utils qpdf ruby ruby-dev

# crypto (arbitrary precision arithmetic)
apt-get install -y --no-install-recommends libgmp-dev libmpc-dev libmpfr-dev pari-gp

# networking and handy dev libraries
apt-get install -y iproute2 inetutils-ping jq net-tools netcat-traditional redis socat tcpdump
apt-get install -y --no-install-recommends \
    libevent-dev libffi-dev libglib2.0-dev libgtest-dev libhiredis-dev \
    libjansson-dev libssl-dev libuv1-dev

# uv: the Python package installer (https://docs.astral.sh/uv/)
curl -LsSf https://astral.sh/uv/install.sh | \
    env UV_INSTALL_DIR=/usr/local/bin INSTALLER_NO_MODIFY_PATH=1 sh

# recent distributions are PEP 668 "externally managed" environments
export UV_SYSTEM_PYTHON=1
export UV_BREAK_SYSTEM_PACKAGES=1
export UV_NO_CACHE=1
export UV_PYTHON_DOWNLOADS=never

# the python tools
uv pip install --upgrade pwntools
uv pip install --upgrade angr
uv pip install --upgrade pycryptodome gmpy2 sympy z3-solver pyasn1 Pillow bitarray

# the tools installed from their git repository
mkdir -p /opt/tools

# gdb extensions
git clone --depth 1 https://github.com/longld/peda.git /opt/tools/peda
git clone --depth 1 https://github.com/hugsy/gef.git /opt/tools/gef
git clone --depth 1 https://github.com/gdbinit/Gdbinit /opt/tools/Gdbinit
git clone --depth 1 https://github.com/pwndbg/pwndbg /opt/tools/pwndbg

# villoc: visualization of heap operations
git clone --depth 1 https://github.com/wapiflapi/villoc.git /opt/tools/villoc
ln -rsf /opt/tools/villoc/villoc.py /usr/local/bin/villoc

# RsaCtfTool: RSA attack tool (mainly for ctf)
# it is a regular python package, which provides the RsaCtfTool command
git clone --depth 1 https://github.com/RsaCtfTool/RsaCtfTool.git /opt/tools/RsaCtfTool
uv pip install /opt/tools/RsaCtfTool

# zsteg: https://github.com/zed-0xff/zsteg
gem install --no-document zsteg

# https://blog.didierstevens.com/programs/pdf-tools/
curl -sL https://didierstevens.com/files/software/pdf-parser_V0_7_14.zip | funzip > /usr/local/bin/pdf-parser.py
chmod a+x /usr/local/bin/pdf-parser.py

apt-get autoremove -y
apt-get clean

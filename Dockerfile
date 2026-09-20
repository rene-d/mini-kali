# mini-kali: a small set of CTF tools (reverse, pwn, crypto) for linux/arm64
FROM kalilinux/kali-rolling

# the base system, the tools and the dev libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    \
    # base system and build toolchain
    apt-get install -y --no-install-recommends \
        bash bash-completion bsdmainutils build-essential bzip2 cmake curl dirmngr file \
        git gawk gnupg htop netbase openssh-client patch pkg-config procps \
        python3-dev python3-pip python3-setuptools sshpass unzip vim wget xxd xz-utils && \
    \
    # debug, disassembly and reverse engineering
    apt-get install -y gdb gdb-multiarch gdbserver strace ltrace checksec radare2 upx-ucl && \
    apt-get install -y --no-install-recommends \
        binutils-arm-linux-gnueabihf binwalk hexedit \
        python3-capstone python3-keystone-engine python3-ropgadget ropper && \
    \
    # forensics, steganography and password cracking
    apt-get install -y foremost john sqlmap steghide stegsnow zbar-tools && \
    apt-get install -y --no-install-recommends imagemagick libimage-exiftool-perl poppler-utils qpdf ruby ruby-dev && \
    \
    # crypto (arbitrary precision arithmetic)
    apt-get install -y --no-install-recommends libgmp-dev libmpc-dev libmpfr-dev pari-gp && \
    \
    # networking and handy dev libraries
    apt-get install -y iproute2 inetutils-ping jq net-tools netcat-traditional redis socat tcpdump && \
    apt-get install -y --no-install-recommends \
        libevent-dev libffi-dev libglib2.0-dev libgtest-dev libhiredis-dev \
        libjansson-dev libssl-dev libuv1-dev && \
    \
    apt-get clean

# set locales to UTF-8
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8 && \
    apt-get clean
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# uv: the Python package installer (https://docs.astral.sh/uv/)
RUN curl -LsSf https://astral.sh/uv/install.sh | \
    env UV_INSTALL_DIR=/usr/local/bin INSTALLER_NO_MODIFY_PATH=1 sh

# Kali is a PEP 668 "externally managed" environment: install into it anyway
ENV UV_SYSTEM_PYTHON=1 \
    UV_BREAK_SYSTEM_PACKAGES=1 \
    UV_NO_CACHE=1 \
    UV_PYTHON_DOWNLOADS=never

# the python tools
RUN set -ex && \
    \
    # http://docs.pwntools.com/ (+ ROPgadget)
    uv pip install --upgrade pwntools && \
    \
    # http://angr.io
    uv pip install --upgrade angr && \
    \
    # crypto and misc (pycrypto is dead, pycryptodome is its maintained fork)
    uv pip install --upgrade pycryptodome gmpy2 sympy z3-solver pyasn1 Pillow bitarray

# the tools installed from their git repository
RUN set -ex && \
    mkdir -p /opt/tools && \
    \
    # gdb extensions
    git clone --depth 1 https://github.com/longld/peda.git /opt/tools/peda && \
    git clone --depth 1 https://github.com/hugsy/gef.git /opt/tools/gef && \
    git clone --depth 1 https://github.com/gdbinit/Gdbinit /opt/tools/Gdbinit && \
    git clone --depth 1 https://github.com/pwndbg/pwndbg /opt/tools/pwndbg && \
    \
    # villoc: visualization of heap operations
    git clone --depth 1 https://github.com/wapiflapi/villoc.git /opt/tools/villoc && \
    ln -rsf /opt/tools/villoc/villoc.py /usr/local/bin/villoc && \
    \
    # RsaCtfTool: RSA attack tool (mainly for ctf)
    # it is a regular python package, which provides the RsaCtfTool command
    git clone --depth 1 https://github.com/RsaCtfTool/RsaCtfTool.git /opt/tools/RsaCtfTool && \
    uv pip install /opt/tools/RsaCtfTool

RUN set -ex ;\
    \
    # zsteg: https://github.com/zed-0xff/zsteg
    gem install --no-document zsteg ;\
    \
    # https://blog.didierstevens.com/programs/pdf-tools/
    curl -sL https://didierstevens.com/files/software/pdf-parser_V0_7_14.zip | funzip > /usr/local/bin/pdf-parser.py ;\
    chmod a+x /usr/local/bin/pdf-parser.py

# the user profile
RUN ln -f /etc/skel/.bashrc /root/.bashrc && \
    touch /root/.hushlogin
COPY bash_aliases /root/.bash_aliases
COPY vimrc /root/.vimrc
COPY gdbinit /root/.gdbinit
COPY disasm.sh asm.sh rootme_ssh *-wrapper /usr/local/bin/
RUN /usr/local/bin/rootme_ssh --add

ARG IMAGE_NAME=kali
VOLUME /${IMAGE_NAME}
WORKDIR /${IMAGE_NAME}

CMD ["bash", "-l"]

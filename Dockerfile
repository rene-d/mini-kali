# docker run --rm -ti --name thug --hostname thug -v $PWD:/thug --cap-add=SYS_PTRACE thug

FROM buildpack-deps:buster

RUN dpkg --add-architecture i386 \
&&  apt-get update \
&&  apt-get upgrade -y \
&&  apt-get install -y gdb gdbserver strace ltrace vim upx python3-dev poppler-utils binwalk ruby netcat bsdmainutils \
&&  apt-get install -y libc6-i386 gcc-multilib g++-multilib \
&&  apt-get clean

# get last version of pip
RUN curl -sL https://bootstrap.pypa.io/get-pip.py | python3 -

# the tools
RUN set -ex \
&&  mkdir -p /opt/tools \
\
# http://docs.pwntools.com/  (+ ROPgadget)
&&  pip3 --no-cache-dir install --upgrade pwntools \
\
# gdb extensions
&&  git clone --depth 1 https://github.com/longld/peda.git /opt/tools/peda \
&&  git clone --depth 1 https://github.com/hugsy/gef.git /opt/tools/gef \
&&  git clone --depth 1 https://github.com/gdbinit/Gdbinit /opt/tools/Gdbinit \
&&  git clone --depth 1 https://github.com/pwndbg/pwndbg /opt/tools/pwndbg \
\
# other tools
&&  git clone --depth 1 https://github.com/slimm609/checksec.sh /opt/tools/checksec.sh \
&&  ln -rsf /opt/tools/checksec.sh/checksec /usr/local/bin/checksec \
\
# ropper, pyasn1, PIL
&&  pip3 install --no-cache-dir ropper pyasn1 Pillow bitarray \
\
# villoc: Visualization of heap operations.
&&  git clone --depth 1 https://github.com/wapiflapi/villoc.git /opt/tools/villoc \
&&  ln -rsf /opt/tools/villoc/villoc.py /usr/local/bin/villoc \
\
# zsteg: https://github.com/zed-0xff/zsteg
&&  gem install zsteg

# new tools
RUN pip3 install angr
RUN apt-get install -y sshpass

# the user profile
RUN ln -f /etc/skel/.bashrc /root/.bashrc
COPY bash_aliases /root/.bash_aliases
COPY vimrc /root/.vimrc
COPY gdbinit /root/.gdbinit
COPY disasm.sh asm.sh rootme /usr/local/bin/

VOLUME /thug
WORKDIR /thug

CMD ["bash", "-l"]

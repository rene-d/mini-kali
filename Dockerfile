FROM kalilinux/kali-rolling

ARG IMAGE_NAME=kali

# the base system
RUN [ "$(uname -m)" = "x86_64" ] && dpkg --add-architecture i386 || true \
&&  apt-get update \
&&  apt-get upgrade -y \
&&  apt-get install -y --no-install-recommends build-essential file patch bzip2 xz-utils curl wget bash git openssh-client procps netbase dirmngr gnupg \
&&  apt-get install -y gdb gdbserver strace vim upx python3-dev poppler-utils ruby netcat bsdmainutils sshpass gawk bash-completion \
&&  [ "$(uname -m)" = "x86_64" ] && apt-get install -y binwalk ltrace libc6-i386 gcc-multilib g++-multilib john foremost sqlmap || true \
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
# ropper, pyasn1, PIL, pycrypto
&&  pip3 install --no-cache-dir ropper pyasn1 Pillow bitarray pycrypto \
\
# villoc: Visualization of heap operations.
&&  git clone --depth 1 https://github.com/wapiflapi/villoc.git /opt/tools/villoc \
&&  ln -rsf /opt/tools/villoc/villoc.py /usr/local/bin/villoc \
\
# zsteg: https://github.com/zed-0xff/zsteg
&&  gem install zsteg \
\
# angr.io, radare2
&&  if [ "$(uname -m)" = "x86_64" ] ; then \
        pip3 install --no-cache-dir angr ; \
        wget -P/tmp -nv https://radare.mikelloc.com/get/4.3.1/radare2_4.3.1_amd64.deb ; \
        dpkg -i /tmp/radare2_4.3.1_amd64.deb ; \
        rm /tmp/radare2_4.3.1_amd64.deb ; \
    fi \
\
# https://blog.didierstevens.com/programs/pdf-tools/
&&  curl -sL http://didierstevens.com/files/software/pdf-parser_V0_7_4.zip | funzip > /usr/local/bin/pdf-parser.py \
&&  chmod a+x /usr/local/bin/pdf-parser.py \
\
&&  echo Done

# set locales to UTF-8
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
&&  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
&&  locale-gen en_US.UTF-8 \
&&  dpkg-reconfigure --frontend=noninteractive locales \
&&  /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# the user profile
RUN ln -f /etc/skel/.bashrc /root/.bashrc
COPY bash_aliases /root/.bash_aliases
COPY vimrc /root/.vimrc
COPY gdbinit /root/.gdbinit
COPY disasm.sh asm.sh rootme_ssh *-wrapper /usr/local/bin/
RUN /usr/local/bin/rootme_ssh --add

VOLUME /${IMAGE_NAME}
WORKDIR /${IMAGE_NAME}

CMD ["bash", "-l"]

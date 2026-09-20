# Mini-Kali

Hacking tools in a Docker image, for **linux/arm64** (Apple Silicon, Raspberry Pi, ARM servers).

A single image gathers the reverse/pwn toolset and the crypto one. The x86_64/i386
image and the SageMath-based crypto image have been removed.


## Build and run

```sh
./build.sh              # build the image and install the launch scripts into ~/.local/bin
./build.sh -i           # install the launch scripts only
./build.sh -n myname    # use another image name (default: kali)

kali                    # run a new container, or attach to the running one
kali start              # start a container in the background
kali-attach list        # list the running containers
kali-attach 2           # attach to container kali_2
```

The current directory is mounted into the container (as `/kali`) and `SYS_PTRACE`
is granted, so that gdb works out of the box.


## Tools

* [kali-rolling](https://hub.docker.com/r/kalilinux/kali-rolling) as the base image, arm64 and armhf targets

Reverse engineering and exploitation

* [gdb](https://www.gnu.org/software/gdb/) and gdb-multiarch, [gdbserver](https://man7.org/linux/man-pages/man1/gdbserver.1.html)
* [gdb-peda](https://github.com/longld/peda) (I can't decide which gdb extension I prefer...)
* [gdb-gef](https://github.com/hugsy/gef)
* [gdb-pwndbg](https://github.com/pwndbg/pwndbg)
* [gdb-gdbinit](https://github.com/gdbinit/Gdbinit)
* [radare2](https://rada.re/)
* [ltrace](https://man7.org/linux/man-pages/man1/ltrace.1.html), [strace](https://strace.io), [file](https://linux.die.net/man/1/file), ...
* [pwntools](https://github.com/Gallopsled/pwntools) (+ ROPgadget), [ropper](https://github.com/sashs/Ropper)
* [capstone](https://www.capstone-engine.org), [keystone](https://www.keystone-engine.org), [unicorn](https://www.unicorn-engine.org)
* [angr.io](https://angr.io)
* [checksec](https://github.com/slimm609/checksec.sh)
* [villoc](https://github.com/wapiflapi/villoc)
* [upx](https://upx.github.io)
* the `arm-linux-gnueabihf` binutils, to deal with 32-bit ARM binaries
* `asm.sh` and `disasm.sh`, to (dis)assemble from the command line (aarch64, or arm with `32`;
  `disasm.sh w` reads instruction words as objdump prints them, rather than a byte dump)
* [uv](https://docs.astral.sh/uv/) installs the Python packages, into the system interpreter

Crypto

* [pycryptodome](https://www.pycryptodome.org), [gmpy2](https://github.com/aleaxit/gmpy), [sympy](https://www.sympy.org), [z3](https://github.com/Z3Prover/z3)
* [RsaCtfTool](https://github.com/RsaCtfTool/RsaCtfTool)
* [PARI/GP](https://pari.math.u-bordeaux.fr)

Forensics, steganography and cracking

* [binwalk](https://github.com/ReFirmLabs/binwalk)
* [foremost](http://foremost.sourceforge.net)
* [zsteg](https://github.com/zed-0xff/zsteg), [steghide](https://steghide.sourceforge.net), [stegsnow](https://www.darkside.com.au/snow/)
* [exiftool](https://exiftool.org), [zbarimg](https://github.com/mchehab/zbar) (QR codes), imagemagick
* [pdf-tools](https://blog.didierstevens.com/programs/pdf-tools/), [qpdf](https://qpdf.sourceforge.io), poppler-utils
* [john](https://github.com/openwall/john)
* [sqlmap](http://sqlmap.org)

Not all useful tools are installed, in order to keep the image in a reasonable size
(~1.1 Gb compressed, ~4.2 Gb once unpacked).

`prepdeb.sh` installs the same toolset directly on a Debian/Kali arm64 host, and
`prepenv.sh` installs the dotfiles and the helper scripts into `$HOME`.


## Removed with the x86 image

These tools are x86-only, or not available on arm64, and are gone with the
amd64/i386 image: `gcc-multilib`, `libc6-i386` (32-bit x86 compilation), `nasm`.
SageMath has no arm64 package either, and its official image is amd64-only; the
crypto image has been replaced by the Python crypto stack listed above.


## Other tools (should be run from/installed on the host machine)

* [Ghidra](https://ghidra-sre.org)
* [IDA Freeware](https://hex-rays.com/ida-free)
* [Stegsolve](http://www.caesum.com/handbook/Stegsolve.jar)
* [trailofbits/manticore](https://github.com/trailofbits/manticore)
```sh
docker run --rm -it --ulimit stack=100000000:100000000 trailofbits/manticore bash
```


## Other links (not exhaustive)

* Linux syscalls [aarch64](https://arm64.syscall.sh) [x86_64](https://filippo.io/linux-syscall-table/) [i386](http://shell-storm.org/shellcode/files/syscalls.html)
* [peepdf](https://github.com/jesparza/peepdf)
* [Steganography Toolkit](https://github.com/DominicBreuker/stego-toolkit)

* [Metasploit](https://github.com/rapid7/metasploit-framework)
    - `docker run --rm -it -v "$HOME/.msf4:/home/msf/.msf4" metasploitframework/metasploit-framework ./msfconsole "$@"`
    - `docker run --rm -it -v "$HOME/.msf4:/home/msf/.msf4" -v "$PWD:/data" metasploitframework/metasploit-framework ./msfvenom "$@"`
* [Miasm](https://github.com/cea-sec/miasm) Reverse engineering framework in Python ([write-up](https://www.root-me.org/fr/Challenges/Cracking/PE-x64-Automatisation-du-crackme?action_solution=voir&debut_affiche_solutions=0#pagination_affiche_solutions))
* [sleuthkit](https://www.sleuthkit.org) command line tools to analyze disk images ([write-up forensic](https://www.root-me.org/fr/Challenges/Forensic/Trouvez-le-chat?action_solution=voir#ancre_solution))
* [volatility](https://volatilityfoundation.org)
* [png-parser](https://github.com/Hedroed/png-parser)
* [chainbreak](https://github.com/n0fate/chainbreaker) Mac OS X Keychain Forensic Tool
* [ctf-tools](https://github.com/zardus/ctf-tools) collection of various security research tools
* [CTF Series : Forensics](https://bitvijays.github.io/LFC-Forensics.html)
* [retargetable decompiler](https://github.com/avast/retdec)
* [vivisect/vivisect](https://github.com/vivisect/vivisect)

* [RSA attack tool (mainly for ctf)](https://github.com/RsaCtfTool/RsaCtfTool)
* [Crypton](https://github.com/ashutosh1206/Crypton)
* [CTF Crypto](https://github.com/ValarDragon/CTF-Crypto)
* [SideChannelMarvels](https://github.com/SideChannelMarvels/)
* [PatchELF](https://github.com/NixOS/patchelf)

Blogs 🇫🇷
* https://k-lfa.info
* https://bases-hacking.org/hacking.html

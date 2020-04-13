# mini-kali

Hacking tools in a Docker image.

## Tools

* [buildpack-deps](https://hub.docker.com/_/buildpack-deps) as the base image
* x86_64 and i386 architectures
* [gdb](https://www.gnu.org/software/gdb/)
* [ltrace](http://man7.org/linux/man-pages/man1/ltrace.1.html), [file](https://linux.die.net/man/1/file), ...
* [binwalk](https://github.com/ReFirmLabs/binwalk)
* [pwntools](https://github.com/Gallopsled/pwntools)
* [checksec](https://github.com/slimm609/checksec.sh)
* [gdb-peda](https://github.com/longld/peda) (I can't decide which gdb extension I prefer...)
* [gdb-pwndbg](https://github.com/pwndbg/pwndbg)
* [gdb-gef](https://github.com/hugsy/gef)
* [gdb-gdbinit](https://github.com/gdbinit/Gdbinit)
* [villoc](https://github.com/wapiflapi/villoc)
* [zsteg](https://github.com/zed-0xff/zsteg)

Not all useful tools are installed to keep the image in a reasonable size (~1.5 Gb).

## Other tools (should be installed on the host machine)

* [Ghidra](https://ghidra-sre.org)
* [IDA Freeware](https://www.hex-rays.com/products/ida/support/download_freeware/)

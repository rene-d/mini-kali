# Mini-Kali

Hacking tools in a Docker image.

![docker](https://www.docker.com/sites/default/files/d8/2019-07/horizontal-logo-monochromatic-white.png)
![kali](https://www.kali.org/wp-content/uploads/2015/09/kali-2.0-website-logo.png)


## Tools

* [kali-rolling](https://hub.docker.com/r/kalilinux/kali-rolling) as the base image
* x86_64 and i386 architectures
* [gdb](https://www.gnu.org/software/gdb/)
* [ltrace](http://man7.org/linux/man-pages/man1/ltrace.1.html), [file](https://linux.die.net/man/1/file), ...
* [binwalk](https://github.com/ReFirmLabs/binwalk)
* [pwntools](https://github.com/Gallopsled/pwntools)
* [checksec](https://github.com/slimm609/checksec.sh)
* [gdb-peda](https://github.com/longld/peda) (I can't decide which gdb extension I prefer...)
* [gdb-gef](https://github.com/hugsy/gef)
* [gdb-pwndbg](https://github.com/pwndbg/pwndbg)
* [gdb-gdbinit](https://github.com/gdbinit/Gdbinit)
* [villoc](https://github.com/wapiflapi/villoc)
* [zsteg](https://github.com/zed-0xff/zsteg)
* [angr.io](http://angr.io)
* [radare2](http://radare.org/)
* [pdf-tools](https://blog.didierstevens.com/programs/pdf-tools/)
* [foremost](http://foremost.sourceforge.net)
* [john](https://github.com/magnumripper/JohnTheRipper)
* [sqlmap](http://sqlmap.org)

Not all useful tools are installed to keep the image in a reasonable size (~1.0 to 1.8 Gb).


## Other tools (should be run from/installed on the host machine)

* [Ghidra](https://ghidra-sre.org)
* [IDA Freeware](https://www.hex-rays.com/products/ida/support/download_freeware/)
* [Stegsolve](http://www.caesum.com/handbook/Stegsolve.jar)
* [trailofbits/manticore](https://github.com/trailofbits/manticore)
```sh
docker run --rm -it --ulimit stack=100000000:100000000 trailofbits/manticore bash
```


## Other links (not exhaustive)

* [peepdf](https://github.com/jesparza/peepdf)
* [Steganography Toolkit](https://github.com/DominicBreuker/stego-toolkit)

* [Metasploit](https://github.com/rapid7/metasploit-framework)
    - `docker run --rm -it -v "$HOME/.msf4:/home/msf/.msf4" metasploitframework/metasploit-framework ./msfconsole "$@"`
    - `docker run --rm -it -v "$HOME/.msf4:/home/msf/.msf4" -v "$PWD:/data" metasploitframework/metasploit-framework ./msfvenom "$@"`
* [Miasm](https://github.com/cea-sec/miasm) Reverse engineering framework in Python ([write-up](https://www.root-me.org/fr/Challenges/Cracking/PE-x64-Automatisation-du-crackme?action_solution=voir&debut_affiche_solutions=0#pagination_affiche_solutions))
* [sleuthkit](https://www.sleuthkit.org) command line tools to analyze disk images ([write-up forensic](https://www.root-me.org/fr/Challenges/Forensic/Trouvez-le-chat?action_solution=voir#ancre_solution))
* [volatility](https://www.volatilityfoundation.org)
* [png-parser](https://github.com/Hedroed/png-parser)
* [chainbreak](https://github.com/n0fate/chainbreaker) Mac OS X Keychain Forensic Tool
* [ctf-tools](https://github.com/zardus/ctf-tools) collection of various security research tools
* [CTF Series : Forensics](https://bitvijays.github.io/LFC-Forensics.html)
* [retargetable decompiler](https://github.com/avast/retdec)
* [vivisect/vivisect](https://github.com/vivisect/vivisect)

* [RSA attack tool (mainly for ctf)](https://github.com/Ganapati/RsaCtfTool)
* https://github.com/ashutosh1206/Crypton
* https://github.com/ValarDragon/CTF-Crypto
* [SideChannelMarvels](https://github.com/SideChannelMarvels/)

Blogs 🇫🇷
* https://k-lfa.info
* https://bases-hacking.org/hacking.html

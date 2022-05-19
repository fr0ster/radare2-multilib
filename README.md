radare2-multilib
=========
This project will include some images aimed to reversing and CTF.

## radare2-multilib image
Old image kind of "all-in-one" type

### Usage
```
docker run --network=host --rm -v $(pwd):/work_dir -it luckycatalex/radare2-multilib:5.6.8  bash
```

## radare2-base
The base image that will be used from other images, you can use him

### Usage
```
docker run --network=host --rm -v $(pwd):/work_dir -it luckycatalex/radare2-base:5.6.8  bash
```

### included software

- [pwntools](https://github.com/Gallopsled/pwntools)  —— CTF framework and exploit development library
- [pwndbg](https://github.com/pwndbg/pwndbg)  —— a GDB plug-in that makes debugging with GDB suck less, with a focus on features needed by low-level software developers, hardware hackers, reverse-engineers and exploit developers
- [pwngdb](https://github.com/scwuaptx/Pwngdb) —— gdb for pwn
- [ROPgadget](https://github.com/JonathanSalwan/ROPgadget)  —— facilitate ROP exploitation tool
- [roputils](https://github.com/inaz2/roputils) 	—— A Return-oriented Programming toolkit
- [one_gadget](https://github.com/david942j/one_gadget) —— A searching one-gadget of execve('/bin/sh', NULL, NULL) tool for amd64 and i386
- [angr](https://github.com/angr/angr)   ——  A platform-agnostic binary analysis framework
- [radare2](https://github.com/radare/radare2) ——  A rewrite from scratch of radare in order to provide a set of libraries and tools to work with binary files
- [seccomp-tools](https://github.com/david942j/seccomp-tools) —— Provide powerful tools for seccomp analysis
- [tmux](https://tmux.github.io/) 	—— a terminal multiplexer
- [ltrace](https://linux.die.net/man/1/ltrace)      —— trace library function call
- [strace](https://linux.die.net/man/1/strace)     —— trace system call

## radare2-r2ghidra

Based on radare2-base and have installed r2ghidra plugin by default

### Usage
```
docker run --network=host --rm -v $(pwd):/work_dir -it luckycatalex/radare2-r2ghidra:5.6.8  bash
```

## radare2-ctf

Based on radare2-r2ghidra

### Usage
```
docker run --network=host --rm -v $(pwd):/work_dir -it luckycatalex/radare2-ctf:5.6.8  bash
```

### included glibc

Default compiled glibc path is `/glibc`.

- 2.19  —— ubuntu 12.04 default libc version
- 2.23  —— ubuntu 16.04 default libc version
- 2.24  —— introduce vtable check in file struct
- 2.27  —— ubuntu 18.04 default glibc version
- 2.28~2.30  —— latest libc versions
- 2.31  —— ubuntu 20.04 default glibc version(built-in)

Can be used for debugging instead system glibc by patchelf
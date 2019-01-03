#!/bin/bash
wget --no-verbose https://flatassembler.net/fasm-1.73.04.tgz --output-document=/tmp/fasm.tgz
tar -xzf /tmp/fasm.tgz -C $PWD
chmod +x fasm/fasm
export PATH="$PATH:$PWD/fasm"
fasm main.asm

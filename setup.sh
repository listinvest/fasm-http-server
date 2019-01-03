#!/bin/bash
wget --no-verbose https://github.com/NadeenUdantha/heroku-buildpack-fasm/raw/master/bin/fasm
chmod +x fasm
fasm main.asm main

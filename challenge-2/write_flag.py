#!/usr/bin/python3

with open("flag-2.png", "rb") as fin:
    flag_bytes = fin.read()

fh = open("Block_dev.img", "r+b") 
fh.seek(int(0x17d75c0)) # code cave on disk to dump data to
fh.write(flag_bytes)
fh.close()

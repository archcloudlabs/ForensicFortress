#!/usr/bin/python3
#fh = open("Block_dev.img", "r+b") 
fh = open("rev.img", "r+b") 
fh.seek(0)
all_data = fh.read()

fh = open("fwd.img", "w+b") 
fh.write(all_data[::-1])

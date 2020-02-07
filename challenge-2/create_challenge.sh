#!/bin/bash
if [[ $(id -u) -ne 0 ]]; then
    echo -e "[!] Error cannot mount block image without sudo privs. Quitting!"
    exit 1;
fi

dd if=/dev/urandom of=Block_dev.img bs=4 count=100000000

#https://superuser.com/questions/332252/how-to-create-and-format-a-partition-using-a-bash-script
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk Block_dev.img
    o # clear the in memory partition table
    n # new partition
    p # primary partition
    1 # partition number 1
    # default - start at beginning of disk 
    +100M # 100 MB boot parttion
    n # new partition
    p # primary partition
    2 # partion number 2
    # default, start immediately after preceding partition
    +100M
    a # make a partition bootable
    1 # bootable partition is partition 1 -- /dev/sda1
    p # print the in-memory partition table
    w # write the partition table
    q # and we're done
EOF

mkfs.exfat Block_dev.img;

mkdir /tmp/data;

sudo mount Block_dev.img /tmp/data;

# Leave empty to hint that there's nothing here.
mkdir -p /tmp/data/{root,lib,etc,home,var,srv,sbin,proc,lib64,dev,boot}

sudo umount /tmp/data;
rmdir /tmp/data;

python3 write_flag.py;
python3 reverse_image.py;
if [[ $? -eq 0 ]]; then
    echo -e "[+] Successfully created challenge."
fi

# Used for debugging/verifying flag is there.
# xxd Block_dev.img > debug_challenge.img
# r2 Block_dev.img -c "s 0x17d75c0; px;" -q

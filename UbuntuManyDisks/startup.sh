#!/bin/bash
#RAID
sudo apt-get update
sudo apt-get install lvm2 -y
sudo apt-get install mc -y
sudo apt-get install fio -y
sudo apt-get install sysstat -y 
sudo apt-get install iotop -y
sudo pvcreate /dev/sd[cdefghij]
sudo vgcreate data-vg01 /dev/sd[cdefghij]
sudo lvcreate --extents 100%FREE --stripes 8 --name data-lv01 data-vg01
sudo mkfs -t ext4 /dev/data-vg01/data-lv01
sudo mkdir /data
sudo echo -e '/dev/data-vg01/data-lv01\t/data\text4\tdefaults,nofail\t0\t2' >> /etc/fstab
sudo mount -a
#Permission
sudo chmod -R 777 /data
#DOCKER
sudo apt install docker.io -y
sudo service docker restart
sudo service docker start
sudo groupadd docker
sudo usermod -aG docker tkopacz
#DOCKER CONF
sudo echo -e '
{
"storage-driver": "overlay2",
"graph": "/data/docker"
}
' >> /etc/docker/daemon.json

#fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=test --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75
#fio random-read-test.fio
#iostat
#iotop
#fio  --filename=data --direct=1 --rw=randread --bs=4k --size=50G --numjobs=64 --iodepth=32 --runtime=120 --group_reporting --name=file1 --ioengine=libaio --thread --gtod_reduce=1
#!/bin/bash
if [ ! -f /opt/simulators/data/xxxx.ini ]; then
    cp /opt/simulators/bin/simh_ini.org /opt/simulators/data/xxxx.ini
fi

if [ ! -f /opt/simulators/bin/xxxx.ini ]; then
    ln -s /opt/simulators/data/xxxx.ini /opt/simulators/bin/
fi

if [ ! -f /opt/simulators/iso/OpenVMS_VAX_7.3.iso ]; then
    cd /opt/simulators/iso
    curl -O "https://fsck.technology/software/DEC-Compaq/OpenVMS%20Install%20Media/OpenVMS%207.3%20VAX/OpenVMS_VAX_7.3.img.bz2"
    bzip2 -d OpenVMS_VAX_7.3.img.bz2
    mv OpenVMS_VAX_7.3.img OpenVMS_VAX_7.3.iso
fi

cd /opt/simulators/bin/

#!/bin/bash
if [ ! -f /opt/simulators/data/es40.cfg ]; then
    cp /opt/simulators/bin/es40.org /opt/simulators/data/es40.cfg
fi

if [ ! -f /opt/simulators/bin/es40.cfg ]; then
    ln -s /opt/simulators/data/es40.cfg /opt/simulators/bin/
fi

if [ ! -f /opt/simulators/iso/ALPHA084.ISO ]; then
    cd /opt/simulators/iso
    curl -O "https://fsck.technology/software/DEC-Compaq/OpenVMS%20Install%20Media/OpenVMS%208.4%20Alpha/ALPHA084.ISO"
fi

cd /opt/simulators/bin/

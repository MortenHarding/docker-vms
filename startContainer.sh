# Script to start docker compose and the services defined in the compose.yml file
# 

# Check if the ISO file exist and download it if it doesn't
if [ ! -f ./iso/OpenVMS_VAX_7.3.iso ]; then
    cd iso
    curl -O "https://fsck.technology/software/DEC-Compaq/OpenVMS%20Install%20Media/OpenVMS%207.3%20VAX/OpenVMS_VAX_7.3.img.bz2"
    bzip2 -d OpenVMS_VAX_7.3.img.bz2
    mv OpenVMS_VAX_7.3.img OpenVMS_VAX_7.3.iso
    cd ..
fi

# Check if the ISO file exist and download it if it doesn't
if [ ! -f ./iso/ALPHA084.ISO ]; then
    cd iso
    curl -O "https://fsck.technology/software/DEC-Compaq/OpenVMS%20Install%20Media/OpenVMS%208.4%20Alpha/ALPHA084.ISO"
    cd ..
fi

# Start all or only 1 service
docker compose up -d $1
if [[ -n "$1" ]]; then
    #If one service is started, show the log output from Docker
    docker logs -f $1
fi

# Remove docker containers when exiting the process
docker compose down
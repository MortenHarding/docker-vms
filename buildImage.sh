docker build --build-arg SIMULATOR=$1 -f Dockerfile-$1 -t mhardingdk/vms:$1 .

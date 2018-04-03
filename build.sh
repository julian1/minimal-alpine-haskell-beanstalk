#!/bin/bash -x

# beanstalk target
target="$(pwd)/beanstalk.zip"

# fail early
set -e

# cleanup
rm -f $target

# step 1. build image
docker build -t build . 

# stripping binaries should be done in the container

# copy binaries and static resources from build image, ready for deploy image
docker run -v $PWD/deploy:/opt/mount --rm --entrypoint cp build:latest /root/project/dist/build/Main/Main /opt/mount/
docker run -v $PWD/deploy:/opt/mount --rm --entrypoint cp build:latest /root/project/static               /opt/mount/ -rp

# step 2. deploy image
docker build -t deploy deploy        

# create a beanstalk zip
pushd deploy && zip -r "$target" * && popd

echo "done"



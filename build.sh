#!/bin/bash -x

# beanstalk target
target="$(pwd)/beanstalk.zip"

# fail early
set -e

# cleanup
rm -f $target

[ -d docker-build/resources  ]  || mkdir docker-build/resources
[ -d docker-deploy/resources  ] || mkdir docker-deploy/resources

# step 1. build image
cp -rp src Test.cabal Setup.hs LICENSE docker-build/resources 
docker build  -t build docker-build


# copy binaries out of image, into dir for deploy
docker run -v $PWD/docker-deploy:/opt/mount --rm --entrypoint cp build:latest /root/project/dist/build/Main/Main /opt/mount/


# step 2. deploy image
cp resources/* -rp  ./docker-deploy/resources
docker build -t deploy docker-deploy 

# create a beanstalk zip
pushd docker-deploy && zip -r "$target" * && popd

echo "done"




### minimal-haskell-beanstalk-alpine

#### Create a simple Beanstalk zip, for a Haskell Warp/Wai service using Docker and Alpine 

To ensure the smallest image is created, the build is performed in two steps,

  - A docker build image - approx 2GB
  - A docker deploy image with binaries only - approx 25MB uncompressed, or 5MB compressed


#### Use:

Install cabal-install, then

```
$ ./build.sh
...
$ ls beanstalk.zip
...
```



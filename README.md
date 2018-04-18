
### minimal-haskell-beanstalk-alpine

#### Create an AWS Beanstalk zip from a Haskell Warp/Wai web-service

To ensure small deployment images, the build is performed in two steps,

  - A docker build image with all compile-time dependencies - approx 2GB
  - A docker deploy image with binaries only - approx 25MB uncompressed, or 5MB compressed


#### Use:


```
$ ./build.sh
...
$ ls beanstalk.zip
...
```



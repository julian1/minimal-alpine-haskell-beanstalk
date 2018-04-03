
minimal-alpine-haskell-beanstalk
----

Create a Beanstalk zip, for a minimal Haskell Warp/Wai service, with Docker and Alpine 

Two images,
  - build,  includes all Cabal build and integration-test dependencies - approx 2GB
  - deploy, Beanstalk image and zip with needed binaries only - approx 25MB, or 5MB compressed

Use:

```
$ ./build.sh
...
$ ls beanstalk.zip
...
```



# note, docker will not follow a symbolic link outside the context
#   see, https://stackoverflow.com/questions/31881904/docker-follow-symlink-outside-context
# and we cannot use a volume either
# so, the Dockerfile should be a toplevel dir, to expose project source

FROM alpine

# alping - update package index and install bash
RUN apk add --update bash

# ghc/cabal
RUN apk add \
        ghc \
        cabal


# use copy or add?
COPY cabal-project /root/project

# build project
WORKDIR /root/project

RUN cabal sandbox init
RUN cabal update
RUN apk add --no-cache musl-dev zlib-dev postgresql-dev
RUN cabal install --only-dependencies 2>&1 | tee log-install.txt
RUN cabal configure 
RUN cabal build 2>&1 | tee log-build.txt




FROM alpine

# alping - update package index and install bash
RUN apk add --update bash

# ghc/cabal
RUN apk add \
        ghc \
        cabal

# project specific lib deps
RUN apk add --no-cache musl-dev zlib-dev postgresql-dev

# env
ENV       w /root/project
RUN mkdir $w
WORKDIR   $w

# first, just copy stable project files
COPY resources/Test.cabal $w
COPY resources/Setup.hs   $w
COPY resources/LICENSE    $w

# test connectivity
# RUN ping -c 4 hackage.haskell.org

# project dependencies
RUN cabal sandbox init
RUN cabal update
RUN cabal install --only-dependencies 2>&1 | tee log-install.txt
RUN cabal configure

# copy volatile project source
COPY resources/src        $w/src

# build it
RUN cabal build Main 2>&1 | tee log-build.txt



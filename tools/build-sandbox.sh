#!/bin/bash -x

cabal sandbox init
cabal update
cabal install --only-dependencies
cabal configure
cabal build

export APP_PATH=resources
cabal run Main


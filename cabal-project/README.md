
Important
Using aeson json - might be a way to do - sql record get/put easily ...
    - inistead of Servant. not sure. rows are pretty easily handled.. 

Use,


- want to move all this up a level. so there's no top-level cabal-project.
  -- or do we. need to move the src. the static dir. 

```
cabal install  # may not need...
cabal configure
cabal run
```


sandbox
```
apt-get install cabal-install
cabal sandbox init
cabal install --dependencies-only --enable-tests
cabal configure
cabal test
cabal run Main
```

refs

- hunit https://hackage.haskell.org/package/HUnit

- more tests https://www.haskell.org/cabal/users-guide/developing-packages.html#test-suites

- cabal sandboxes http://coldwa.st/e/blog/2014-08-20-Cabal-sandbox.html

- logging middleware example,
  https://github.com/algas/haskell-servant-cookbook/blob/master/doc/Logger.md

- application routing
  see, https://hackage.haskell.org/package/wai-3.2.1.1/docs/Network-Wai.html

- default settings,
  https://hackage.haskell.org/package/warp-3.2.18.2/docs/Network-Wai-Handler-Warp.html

- ssl
  https://github.com/algas/haskell-servant-cookbook/blob/master/doc/Https.md

- response
  https://hackage.haskell.org/package/wai-3.0.2.2/docs/Network-Wai.html#t:Response

- middleware to log response time
  https://stackoverflow.com/questions/26020428/logging-response-time-in-yesod

- log middleware... 
  http://hackage.haskell.org/package/wai-extra-3.0.2.1/docs/src/Network-Wai-Middleware-RequestLogger.html#detailedMiddleware

- compose middleware
  https://stackoverflow.com/questions/41061044/haskell-servant-wai-middleware-not-working-properly

- IO inside application
  https://stackoverflow.com/questions/7771523/how-do-i-perform-io-inside-a-wai-warp-application

- wai static middleware
  https://hackage.haskell.org/package/wai-middleware-static-0.8.1/docs/Network-Wai-Middleware-Static.html

- wai session. for cookies...


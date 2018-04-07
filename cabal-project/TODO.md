
----

OKO - putting code on top level - will improve speed. because it won't have to keep  
        downloading.... cabal. i think.


- static files. eg. with a list of urls that require hitting postgres.
  looks like there is middleware to do this,
  https://hackage.haskell.org/package/wai-middleware-static-0.8.1/docs/Network-Wai-Middleware-Static.html

- need to hit concurrently.... though. using a bash loop doesn't do this.
- database pool/conns, sleep 1.  stress test.  forkIO example.

-- TODO expose pool parameters to config...
      - eg. resource pool size limit also.


- systemd service file
- docker  - so it gets called instead of init
    https://www.fpcomplete.com/blog/2015/05/haskell-web-server-in-5mb

- prod
    https://groups.google.com/forum/#!msg/yesodweb/gJeUT3uUIkg/rcDaEtLUFVkJ

- tls - apache proxy or... , or investiage warp tls, 

- there's  an issue that just using print, putstrln etc. will get mixed up in the output log, when running concurrently.

----



done - - add extra stuff to log, from computation ...
  - perhaps need vault - to hold value.
  - actually think we just log to stdout. although not sure how this gets sequenced. 

done - confirm apt-get deps for debian/ubuntu

done - config - json - aeson. or else command line.

- done - nginx host pass through... for logging.

- need to flesh out unit tests. HUnit. 
  
- done - serve top level page. thought / or index.htm would work.
- done - logging.
- done - test code.
- done - dependencies
- done - aeson example.

-----





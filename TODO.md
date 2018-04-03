
- logging of exec.



- spawn local postgres instance in build/integration step to run integration tests
- use cli tools eg. eb deploy   

----


- index.html - or rewrite rules - or static - is not working 
  fix static files not being served by server - probably a path issue.. static is not included.... at all.

- want haskell Main api to print starting env - to diagnose static path issues

- done ensure can run deploy container locally, as well..
- done - get copying build artifact out, working scripted - before building host.
- done - aws 

- done - run on elastic beanstalk.
- done - zip appears to be done from inside the dir - so that there's no top level.
    debian:~/docker$ zip -r ../abc.zip *

- done - it wants to build the image from scratch again? weird.
, 

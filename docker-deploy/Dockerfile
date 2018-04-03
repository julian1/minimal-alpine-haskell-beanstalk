
FROM alpine

# alping - update package index and install bash
RUN apk add --update bash

# warp/wai deps
RUN apk add libpq libffi libgmpxx

# copy our binary
COPY Main                   /root/

# copy resources
COPY resources/Config.json  /root/
COPY resources/static       /root/static

# set app path
ENV APP_PATH=/root

# beanstalk wants both of these
EXPOSE 3000
CMD [ "/root/Main" ]
 

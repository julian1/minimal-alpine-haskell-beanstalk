
FROM alpine

# alping - update package index and install bash
RUN apk add --update bash

# warp/wai deps
RUN apk add libpq libffi libgmpxx

# copy binaries and resources
COPY Main   /root/
COPY static /root/static

# app path for resources
ENV APP_PATH=/root

# beanstalk wants both of these
EXPOSE 3000
CMD [ "/root/Main" ]
 
#entrypoint


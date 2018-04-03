#!/bin/bash

if [ -z $1 ]; then
  echo "need image arg! ie <build or deploy>"
  exit 1
fi

docker run -i -w /root -t $1:latest /bin/bash


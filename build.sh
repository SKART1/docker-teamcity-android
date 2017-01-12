#!/bin/bash
TAG=tc-agent
FILE=image.tar

#Clean previous
rm -f ${FILE}

docker build -t ${TAG} .
docker save -o ${FILE} ${TAG}
scp ${FILE} artur@android-tc.odkl.ru:/home/artur/${FILE} 
#ssh artur@android-tc.odkl.ru 
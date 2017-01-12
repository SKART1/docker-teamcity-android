#!/bin/bash
TC_AGENT1=tc-agent1
TC_AGENT2=tc-agent2

TAG=tc-agent
FILE=image.tar

#Remove old
docker kill ${TC_AGENT1}
docker kill ${TC_AGENT2}
docker rm ${TC_AGENT1}
docker rm ${TC_AGENT2}

#Load new
docker rmi ${TAG}
docker load -i ${FILE}





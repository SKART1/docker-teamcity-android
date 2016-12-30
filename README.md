# docker-teamcity-android
Simple docker agent with android sdk inside it


## Starting

Script example:

```
docker run -e SERVER_URL="172.18.89.85:8080"  \
    -v ${1}:/opt/buildagent/work/     \
    -v ${2}:/opt/buildagent/temp/     \
    -d \
    -v /etc/ssl/certs:/etc/ssl/certs:ro \
    -p ${3}:9090 \
    --name ${4} \
    tc-agent:latest
```

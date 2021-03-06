FROM jetbrains/teamcity-agent

#All
ENV DEBIAN_FRONTEND=noninteractive

#Java
ENV ORACLE_JDK=/usr/lib/jvm/oracle-jdk/jre/ \
    OPEN_JDK=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre

#Packages for sdk
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y software-properties-common libncurses5:i386 libstdc++6:i386 zlib1g:i386 expect wget curl git build-essential \
    && apt-get update \
    && apt-get autoclean
    
    
#Android sdk settings
ENV ANDROID_SDK_VERSION=r24.4.1 \
    ANDROID_BUILD_TOOLS_VERSION=25.0.2 \
    ANDROID_API_LEVELS=android-22,android-23,android-24,android-25 \
    EXTRA_PACKAGES=build-tools-23.0.3,build-tools-24.0.2 \
    \
    ANDROID_HOME=/opt/android-sdk-linux 
    
ENV ANDROID_SDK_FILENAME=android-sdk_${ANDROID_SDK_VERSION}-linux.tgz 
ENV ANDROID_SDK_URL=http://dl.google.com/android/${ANDROID_SDK_FILENAME} 

ENV PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

#Actually sdk    
RUN cd /opt \
    && wget -q ${ANDROID_SDK_URL} \
    && tar -xzf ${ANDROID_SDK_FILENAME} \
    && rm ${ANDROID_SDK_FILENAME} \
    && echo y | android update sdk --no-ui -a --filter tools,platform-tools,extra,${ANDROID_API_LEVELS},build-tools-${ANDROID_BUILD_TOOLS_VERSION},${EXTRA_PACKAGES}

#Certificates for java
COPY trust-certs/ /usr/local/share/ca-certificates/
RUN update-ca-certificates && \
    ls -1 /usr/local/share/ca-certificates | while read cert; do \
        openssl x509 -outform der -in /usr/local/share/ca-certificates/$cert -out $cert.der; \
        #Oracle jdk
        ${ORACLE_JDK}/bin/keytool -import -alias $cert -keystore ${ORACLE_JDK}/lib/security/cacerts -trustcacerts -file $cert.der -storepass changeit -noprompt; \
        #Open jdk
        ${OPEN_JDK}/bin/keytool -import -alias $cert -keystore ${OPEN_JDK}/lib/security/cacerts -trustcacerts -file $cert.der -storepass changeit -noprompt; \
        rm $cert.der; \
    done

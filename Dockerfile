FROM jetbrains/teamcity-agent

#Packages for sdk
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y software-properties-common libncurses5:i386 libstdc++6:i386 zlib1g:i386 expect wget curl git build-essential \
    && apt-get update \
    && apt-get autoclean
    
    
#Android sdk settings
ENV ANDROID_SDK_VERSION=r24.4.1 \
    ANDROID_BUILD_TOOLS_VERSION=24.0.2 \
    ANDROID_API_LEVELS=android-22,android-23,android-24 \
    EXTRA_PACKAGES=build-tools-23.0.3 \
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
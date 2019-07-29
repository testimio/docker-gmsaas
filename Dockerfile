FROM python:3-slim-stretch

RUN apt-get update && apt-get install wget unzip -y

# download and install Android SDK
# https://developer.android.com/studio/#downloads
ARG ANDROID_SDK_VERSION=4333796
ENV ANDROID_HOME /opt/android-sdk
RUN mkdir -p ${ANDROID_HOME} && cd ${ANDROID_HOME} && \
    wget -q https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip && \
    unzip *tools*linux*.zip && \
    rm *tools*linux*.zip

# install genymotion cli
RUN pip3 install gmsaas && \
    gmsaas config set android-sdk-path ${ANDROID_HOME}

ENTRYPOINT ["gmsaas"]

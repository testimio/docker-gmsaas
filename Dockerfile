FROM openjdk:8-jdk-slim AS android-install

RUN apt-get update && apt-get install wget unzip -y

# download and install Android SDK
# https://developer.android.com/studio/#downloads
ARG ANDROID_SDK_VERSION=4333796
ENV ANDROID_HOME=/opt/android-sdk
RUN mkdir -p ${ANDROID_HOME} && cd ${ANDROID_HOME} && \
    wget -q https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip && \
    unzip *tools*linux*.zip && \
    rm *tools*linux*.zip
ENV PATH=${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}

RUN mkdir ~/.android && echo '### User Sources for Android SDK Manager' > ~/.android/repositories.cfg

RUN yes | sdkmanager --licenses && yes | sdkmanager --update

# Update SDK manager and install system image, platform and build tools
RUN sdkmanager tools platform-tools

FROM python:3.5-slim-stretch
RUN apt-get update && apt-get install libgtk2.0-dev wget -y

ENV ANDROID_HOME=/opt/android-sdk
COPY --from=android-install $ANDROID_HOME $ANDROID_HOME
ENV PATH=${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}

# install genymotion cli
RUN pip3 install gmsaas && \
    gmsaas config set android-sdk-path ${ANDROID_HOME}

CMD ["gmsaas"]

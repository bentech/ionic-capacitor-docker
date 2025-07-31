# Use Node.js 20 LTS on Debian (bullseye) for a lighter base image
FROM node:20-bullseye

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm \
    ANDROID_SDK_ROOT=/opt/android \
    ANDROID_HOME=/opt/android \
    ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
    ANDROID_BUILD_TOOLS_VERSION=34.0.0 \
    IONIC_VERSION=7.2.0 \
    CAPACITOR_VERSION=7.0.1

# Install dependencies (only necessary packages)
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    openjdk-17-jdk-headless \
    curl \
    git \
    unzip \
    openssh-client \
    wget \
    maven \
    jq \
    ant \
    zip \
    gradle && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

    # Install Ionic
RUN npm install -g @ionic/cli@${IONIC_VERSION} && ionic --version
RUN npm install -g @capacitor/cli@${CAPACITOR_VERSION} && cap --version

# Install Android SDK Command Line Tools
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    cd ${ANDROID_SDK_ROOT} && \
    wget -O tools.zip ${ANDROID_SDK_URL} && \
    unzip tools.zip -d cmdline-tools && \
    rm tools.zip && \
    mv cmdline-tools/cmdline-tools cmdline-tools/latest

# Set Android SDK paths
ENV PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/build-tools/${ANDROID_BUILD_TOOLS_VERSION}:$PATH"

# Accept Android SDK licenses and install necessary components
RUN mkdir -p /root/.android && touch /root/.android/repositories.cfg && \
    yes | sdkmanager "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" && \
    yes | sdkmanager "platforms;android-33" "platforms;android-34" && \
    yes | sdkmanager "extras;google;google_play_services" "extras;google;m2repository"

USER node

# Set work directory
WORKDIR /app

# Set entrypoint script
ENTRYPOINT ["/bin/bash", "--", "/var/build/start.sh"]

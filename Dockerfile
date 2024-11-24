# Dockerfile
FROM ubuntu:22.04

# Set environment variables
ENV FLUTTER_HOME=/opt/flutter
ENV FLUTTER_VERSION=3.24.3
ENV PATH=$FLUTTER_HOME/bin:$PATH

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Download and setup Flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME && \
    cd $FLUTTER_HOME && \
    git fetch && \
    git checkout $FLUTTER_VERSION

# Setup Android SDK
ENV ANDROID_HOME=/root/Android/sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# Create necessary directories
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools/latest

# Download and setup Android command-line tools
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip commandlinetools-linux-9477386_latest.zip && \
    mv cmdline-tools/* ${ANDROID_HOME}/cmdline-tools/latest/ && \
    rm -rf cmdline-tools commandlinetools-linux-9477386_latest.zip

# Accept licenses and install Android SDK packages
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"


# Set up workspace
WORKDIR /app
COPY . .

# Initialize and update submodules
RUN git submodule update --init --recursive

# Pre-download Flutter dependencies
RUN flutter precache
RUN flutter doctor -v

# Install project dependencies
RUN flutter pub get

RUN dart run build_runner build --delete-conflicting-outputs

# Build APK with flavor - ARM64 only
RUN flutter build apk --flavor direct --target lib/flavors/direct/main.dart --target-platform android-arm64
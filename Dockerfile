# Dockerfile
FROM ghcr.io/cirruslabs/flutter:stable

WORKDIR /app
COPY . .

# Initialize and update submodules
RUN git submodule update --init --recursive

# Install dependencies
RUN flutter pub get

RUN dart run build_runner build --delete-conflicting-outputs

# Build APK with flavor - ARM64 only
RUN flutter build apk --flavor direct --target lib/flavors/direct/main.dart --target-platform android-arm64
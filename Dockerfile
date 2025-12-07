# Install Operating system and dependencies
FROM ubuntu:20.04 AS build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback python3
RUN curl -sL https://deb.nodesource.com/setup_21.x -o /tmp/nodesource_setup.sh
RUN bash /tmp/nodesource_setup.sh
RUN apt-get install -y nodejs
RUN apt-get clean

ENV DEBIAN_FRONTEND=dialog
ENV PUB_HOSTED_URL=https://pub.flutter-io.cn
ENV FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# download Flutter SDK from Flutter Github repo
RUN git clone -b 3.27.3 https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor

# Enable flutter web
# RUN flutter channel master
# RUN flutter upgrade
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter pub get
# RUN flutter pub outdated
# RUN flutter pub upgrade --major-versions
# RUN npm install --verbose
# RUN npm run cli:web

RUN flutter build web --target lib/flavors/web/main.dart --no-web-resources-cdn && chmod +x postbuild.sh && ./postbuild.sh

# Stage 2: Build the final production image with Nginx
FROM nginx:alpine AS production

## Copy built flutter web app from the build stage to Nginx web root
COPY --from=build /app/build/web /usr/share/nginx/html

## Copy the custom Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

## Expose port 80 to the outside world
EXPOSE 80

## Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
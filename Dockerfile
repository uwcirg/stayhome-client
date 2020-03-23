# https://kevinwilliams.dev/blog/building-a-flutter-web-container
#Stage 1 - Install dependencies and build the app
FROM debian:latest AS build-env

# Copy files to container
RUN mkdir /usr/local/stayhome
COPY . /usr/local/stayhome
WORKDIR /usr/local/stayhome
RUN rm -rf .packages .flutter-plugins .flutter-plugin-dependencies

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends xz-utils git ca-certificates unzip && apt-get clean

# Install Flutter beta
ADD https://storage.googleapis.com/flutter_infra/releases/beta/linux/flutter_linux_v1.15.17-beta.tar.xz /tmp/flutter_linux_v1.15.17-beta.tar.xz
RUN tar xf /tmp/flutter_linux_v1.15.17-beta.tar.xz -C /usr/local

# Run flutter doctor and set path
RUN /usr/local/flutter/bin/flutter doctor -v
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:$PATH"

# Enable flutter web
RUN flutter config --enable-web

# Build
RUN /usr/local/flutter/bin/flutter build web

# Stage 2 - Create the run-time image
FROM nginx
COPY --from=build-env /usr/local/stayhome/build/web /usr/share/nginx/html

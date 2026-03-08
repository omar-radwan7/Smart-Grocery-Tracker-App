FROM ubuntu:22.04

ENV DEBIAN_FRONTEND="noninteractive"

# Install prerequisites
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter (stable channel)
ENV FLUTTER_HOME=/opt/flutter
ENV PATH=${FLUTTER_HOME}/bin:${PATH}

RUN git clone https://github.com/flutter/flutter.git -b stable ${FLUTTER_HOME}
RUN flutter doctor
RUN flutter config --enable-web

WORKDIR /app

# Copy dependency files first to utilize Docker layer caching
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the project
COPY . .

# Build the web version
RUN flutter build web

# Serve the web build on port 8085 using a simple Python HTTP server
EXPOSE 8085
CMD ["python3", "-m", "http.server", "8085", "--directory", "build/web"]

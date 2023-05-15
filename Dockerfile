FROM appimagecrafters/appimage-builder:latest

# Prerequesites
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils curl wget git ca-certificates gcc libc-dev file

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Get project and compile
RUN mkdir -p /resize-my-knight
COPY images /resize-my-knight/images
COPY src /resize-my-knight/src
COPY ui /resize-my-knight/ui
COPY app.desktop AppImageBuilder.yml build.rs Cargo.lock Cargo.toml icon.png /resize-my-knight/
COPY AppImageBuilder.yml /
WORKDIR /resize-my-knight
RUN cargo build --release
WORKDIR /

# Configure AppDir
RUN mkdir -p AppDir/usr/bin/
RUN mkdir -p AppDir/usr/share/icons/hicolor/256x256/apps/
RUN cp /resize-my-knight/app.desktop AppDir
RUN cp /resize-my-knight/target/release/resize-my-knight AppDir/AppRun
RUN chmod +x AppDir/AppRun
RUN cp /resize-my-knight/icon.png AppDir/
RUN cp -R /resize-my-knight/images AppDir
RUN mv AppDir resize-my-knight.AppDir

# Build AppImage
RUN appimagetool resize-my-knight.AppDir
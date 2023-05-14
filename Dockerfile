FROM ubuntu:14.04

# Prerequesites
RUN apt-get update && apt-get install -y --no-install-recommends curl wget git ca-certificates gcc libc-dev file

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Get project and compile
RUN git clone https://github.com/loloof64/resize-my-knight.git
WORKDIR /resize-my-knight
RUN cargo build --release
WORKDIR /

# Configure AppDir
RUN mkdir -p AppDir/usr/bin/
RUN mkdir -p AppDir/usr/share/icons/hicolor/256x256/apps/
RUN cp /resize-my-knight/app.desktop AppDir
RUN cp /resize-my-knight/target/release/resize-my-knight AppDir/usr/bin/
RUN cp /resize-my-knight/icon.png AppDir/usr/share/icons/hicolor/256x256/apps/
RUN cp -R /resize-my-knight/images AppDir
RUN mv AppDir resize-my-knight.AppDir

# Download appimagebuilder
RUN wget https://github.com/AppImageCrafters/appimage-builder/releases/download/v1.1.0/appimage-builder-1.1.0-x86_64.AppImage -O /usr/local/bin/appimage-builder
RUN chmod +x /usr/local/bin/appimage-builder
# Path appimagetool magic byte: https://github.com/AppImage/pkg2appimage/issues/373#issuecomment-495754112
RUN sed -i 's|AI\x02|\x00\x00\x00|' /usr/local/bin/appimage-builder
# Extract AppImage and run
RUN /usr/local/bin/appimage-builder --appimage-extract
RUN squashfs-root/AppRun --appdir resize-my-knight.AppDir
# Delete the folder
RUN rm -rf squashfs-root

# Download appimagetool
RUN wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$(uname -m).AppImage -O /usr/local/bin/appimagetool
RUN chmod +x /usr/local/bin/appimagetool
# Path appimagetool magic byte: https://github.com/AppImage/pkg2appimage/issues/373#issuecomment-495754112
RUN sed -i 's|AI\x02|\x00\x00\x00|' /usr/local/bin/appimagetool
# Extract AppImage and run
RUN /usr/local/bin/appimagetool --appimage-extract
RUN squashfs-root/AppRun resize-my-knight.AppDir
# Delete the folder
RUN rm -rf squashfs-root
FROM ubuntu:18.04

# Prerequesites
RUN apt-get update && apt-get install -y --no-install-recommends curl wget git ca-certificates gcc libc-dev file

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Cargo AppImage
RUN cargo install cargo-appimage

# Get project
RUN git clone https://github.com/loloof64/resize-my-knight.git
WORKDIR /resize-my-knight

# Download appimagetool
RUN wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$(uname -m).AppImage -O /usr/local/bin/appimagetool
RUN chmod +x /usr/local/bin/appimagetool
# Path appimagetool magic byte: https://github.com/AppImage/pkg2appimage/issues/373#issuecomment-495754112
RUN sed -i 's|AI\x02|\x00\x00\x00|' /usr/local/bin/appimagetool
# Use appimagetool without fuse: https://github.com/AppImage/AppImageKit/wiki/FUSE#docker
RUN cargo appimage
# Resize my knight

Just resize the window : and so will the knight.

## Building

### Prerequesites

* install Rustup
* install Podman

### Linux (AppImage)

1. `podman build -t resize-my-knight .`
2. `podman run --rm -ti -v #MyShareFolder#:/share localhost/resize-my-knight:latest /bin/bash` where #MyShareFolder# is the folder you want to share, in your host system, with the container. So inside the container :
   1. `cp *.AppImage /share`
   2. `exit`
So that the built AppImage will be in your shared folder.

## CREDITS

Knight vector has been taken from [Wikimedia Commons](https://commons.wikimedia.org/wiki/Category:SVG_chess_pieces).

Icon has been downloaded from https://fr.freepik.com/vecteurs-libre/concept-isometrique-jeu-echecs_6883519.htm.
# ionic-capacitor-docker
🚀 **Lightweight Docker image for Ionic & Capacitor development** with Android SDK support.

This image includes:

- ✅ **Node.js 22 LTS** (Debian Bookworm)
- ✅ **Ionic CLI 7.2.0**, **Capacitor CLI 7.0.1** & **Capgo CLI 8.45.1**
- ✅ **Android SDK & Build Tools (34.0.0)**
- ✅ **OpenJDK 17** for Android builds

## Usage
Pull the image and start a container:
```sh
docker run --rm -it -p 8100:8100 -v $(pwd):/app bentech/ionic-capacitor-docker
```

# Start from a Debian base image which is common for devcontainers
FROM mcr.microsoft.com/devcontainers/base:bullseye

# Install dependencies needed for the RPi image build script and for act
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
    # Dependencies for the build script
    qemu-user-static binfmt-support wget unzip pigz parted \
    # Dependencies for installing docker & act
    ca-certificates curl gnupg sudo

# Install 'act' for running workflows locally
RUN curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | bash -s -- -b /usr/local/bin

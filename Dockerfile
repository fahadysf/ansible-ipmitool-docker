FROM alpine:3.22

# Update package index and install required packages
RUN apk update && \
    apk add --no-cache \
    ipmitool \
    ansible \
    python3 \
    py3-pip \
    openssh-client

# Set working directory
WORKDIR /ansible

# Default command
CMD ["/bin/sh"]
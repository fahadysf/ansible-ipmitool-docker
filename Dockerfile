FROM alpine:3.22

# Add metadata labels
LABEL maintainer="fahadysf@gmail.com" \
      description="Alpine Linux with Ansible and IPMITOOL" \
      version="1.0.0"

# Update package index and install required packages
RUN apk update && \
    apk add --no-cache \
    ipmitool \
    ansible \
    python3 \
    py3-pip \
    openssh-client && \
    rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /ansible

# Default command
CMD ["/bin/sh"]
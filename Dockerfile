# Use Ubuntu as base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_VERSION=16

# Install essential tools and dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (version 16)
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest

# Set up working directory
WORKDIR /app

# Copy the MERN app into the container
COPY . .

# Install app dependencies
RUN cd frontend && npm install && npm run build
RUN npm install

# Expose necessary ports
EXPOSE 3000 5000

# Start the MERN server
CMD ["npm", "run", "server"]

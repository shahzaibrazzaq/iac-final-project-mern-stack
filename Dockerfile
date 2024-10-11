# Use an official Ubuntu as a parent image
FROM ubuntu:22.04 AS builder

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_VERSION=18.x

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    && curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} \
    | bash - \
    && apt-get install -y nodejs \
    && apt-get install -y mongodb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the frontend and backend files
COPY ./frontend ./frontend
COPY ./backend ./backend

# Install frontend dependencies
WORKDIR /app/frontend
RUN npm install

# Install backend dependencies
WORKDIR /app/backend
RUN npm install

# Expose ports (adjust these as necessary)
EXPOSE 3000 5000

# Start MongoDB, backend, and frontend
CMD service mongodb start && \
    (cd /app/backend && npm start) & (cd /app/frontend && npm start)



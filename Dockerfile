# Use Node.js image as base, which already has Node.js and npm
FROM node:20-buster AS build

RUN apt-get update && \
    apt-get install -y curl gnupg lsb-release git && \
    rm -rf /var/lib/apt/lists/*

# Install MongoDB
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg && \
    echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/8.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-8.0.list && \
    apt-get update && \
    apt-get install -y mongodb-org && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Clone the repository (same as in your original)
RUN git clone https://github.com/shahzaibrazzaq/iac-final-project-mern-stack.git .

WORKDIR /app/backend
RUN npm install

WORKDIR /app/frontend
RUN npm install
RUN npm run build

WORKDIR /app

# Expose required ports
EXPOSE 5000 27017

RUN mkdir -p /data/db

# CMD: Start MongoDB and the backend server
CMD ["sh", "-c", "mongod --bind_ip_all --dbpath /data/db --logpath /var/log/mongodb.log --fork && npm run server"]

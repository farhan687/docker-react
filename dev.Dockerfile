# Base image
FROM node:alpine

WORKDIR '/app'

COPY package.json .
# Download and install dependency
RUN npm install

COPY . .

# Startup command
CMD ["npm", "run", "start"]

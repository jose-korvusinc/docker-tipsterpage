FROM node:24-slim

RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY apiekans/package*.json ./
RUN npm install

COPY apiekans/ .

COPY envs/.env.apiekans .env

CMD ["npm", "run", "start:dev"]
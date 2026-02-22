FROM node:24-slim

RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY apibagon/package*.json ./
RUN npm install

COPY apibagon/ .

COPY envs/.env.apibagon .env

CMD ["npm", "run", "start:dev"]
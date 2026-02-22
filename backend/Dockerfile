
FROM node:24-bookworm-slim

RUN apt-get update && apt-get install -y \
    openjdk-17-jre-headless \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN npm install -g firebase-tools

WORKDIR /app

COPY backend/ .

RUN cd functions && npm install && npm run build

EXPOSE 2030 4000 5001 8082 9099 4400

WORKDIR /app/functions

CMD ["npm", "run", "start", "--", "--host", "0.0.0.0", "--port", "2030"]
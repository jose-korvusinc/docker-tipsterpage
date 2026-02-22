FROM node:24-bookworm

RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN npm install -g @angular/cli firebase-tools lodash-es

COPY admin/ .

RUN npm install --legacy-peer-deps --ignore-scripts

EXPOSE 4200

ENV CHOKIDAR_USEPOLLING=true

CMD sh -c "ng serve --host 0.0.0.0 --port 4200 --disable-host-check --public-host admin.tipsterpage.test"
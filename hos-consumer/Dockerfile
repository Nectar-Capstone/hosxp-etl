FROM node:alpine

WORKDIR /app

COPY package.json package-lock.json ./
COPY package*.json ./

COPY prisma ./prisma/

COPY .env ./

COPY tsconfig.json ./

RUN npm install

COPY . .

RUN npx prisma generate

CMD npm run start
# FROM node:alpine AS builder
# WORKDIR /app
# COPY . .
# RUN npm install
# RUN npm run build 

# FROM node:alpine AS final 
# WORKDIR /app
# ENV DATABASE_URL="mysql://root:password@localhost:8080/hosxp_prisma"
# COPY --from=builder ./app/dist ./dist
# COPY package*.json .
# RUN npm install
# CMD ["npm","run","start"]

FROM node:alpine

# Create directory that runs the app on docker
WORKDIR /app

# COPY package.json and package-lock.json files
COPY package.json package-lock.json ./
COPY package*.json ./

# COPY
COPY prisma ./prisma/

# COPY ENV variable
COPY .env ./

# COPY tsconfig.json file
COPY tsconfig.json ./

# Install package.json dependencies
RUN npm install

# COPY
COPY . .

# Generate prisma client
RUN npx prisma generate

# A command to start the server
CMD npm start
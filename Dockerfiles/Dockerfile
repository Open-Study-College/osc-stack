# base node image
FROM node:16-bullseye-slim as base

# set for base and all layer that inherit from it
ENV NODE_ENV production

# Install openssl for Prisma
RUN apt-get update && apt-get install -y openssl sqlite3

# Install all node_modules, including dev dependencies
FROM base as deps

WORKDIR /myapp

ADD package.json package-lock.json ./
RUN npm install --production=false

# Setup production node_modules
FROM base as production-deps

WORKDIR /myapp

COPY --from=deps /myapp/node_modules /myapp/node_modules
ADD package.json package-lock.json ./
RUN npm prune --production

# Build the app
FROM base as build

WORKDIR /myapp

COPY --from=deps /myapp/node_modules /myapp/node_modules

ADD prisma .
RUN npx prisma generate

ADD . .
RUN npm run build

# Finally, build the production image with minimal footprint
FROM base

ENV PORT="8080"
ENV NODE_ENV="production"
ENV VAPID_PUBLIC_KEY="BNEalBKv4PPkaCfptTW582JLDjMqQzw6CUM6ZdP3mRMEndhRrkLhtBcwoterpS-n4Bghce1WEPPbVgj-2vOKaxw"
ENV VAPID_PRIVATE_KEY="J6XOwjUQ9qLZpu8WC_srpcoisPTaSSyJE_FpFCI01ng"

WORKDIR /myapp

COPY --from=production-deps /myapp/node_modules /myapp/node_modules
COPY --from=build /myapp/node_modules/.prisma /myapp/node_modules/.prisma

COPY --from=build /myapp/build /myapp/build
COPY --from=build /myapp/public /myapp/public

ADD . .

# RUN mkdir -p prisma
# COPY ./prisma /app/prisma

EXPOSE 3306
EXPOSE 8080

ARG MY_DB_URL
ENV PLANETSCALE_PRISMA_DATABASE_URL="${MY_DB_URL}?sslaccept=strict&sslcert=./cacert.pem"
RUN npx prisma db push --accept-data-loss
ENV PLANETSCALE_PRISMA_DATABASE_URL='mysql://uigxviu3luuk:pscale_pw_X4U38z1F5q8cz-1jxbVjmmBLKX7vG1_74g5iuZEJNuc@kwig92irdb0v.eu-west-3.psdb.cloud/osc-academic?sslaccept=strict&sslcert=./cacert.pem'
RUN npx prisma db push --accept-data-loss
CMD ["npm", "start"]

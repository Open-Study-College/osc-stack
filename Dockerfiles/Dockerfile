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

ARG PLANETSCALE_SERVICE_TOKEN_ID
ARG PLANETSCALE_SERVICE_TOKEN
ARG ORG_NAME
ARG DB_NAME
ARG GITHUB_USER
ARG BRANCH_NAME
ARG DIR
ARG FROM

ENV PLANETSCALE_SERVICE_TOKEN_ID = "${PLANETSCALE_SERVICE_TOKEN_ID}"
ENV PLANETSCALE_SERVICE_TOKEN = "${PLANETSCALE_SERVICE_TOKEN}"
ENV ORG_NAME = "${ORG_NAME}"
ENV DB_NAME = "${DB_NAME}"
ENV GITHUB_USER = "${GITHUB_USER}"
ENV BRANCH_NAME = "${BRANCH_NAME}"
ENV DIR = "${DIR}"
ENV FROM = "${FROM}"

ENV PLANETSCALE_PRISMA_DATABASE_URL='mysql://7xc0l0rrnjsw:pscale_pw_wzlLK_oaPmvvvNLZY9FH-ZO-2-dASA2xdtd5pXsoee0@nexhi31uvoo0.eu-west-3.psdb.cloud/osc-academic?sslaccept=strict&sslcert=./cacert.pem'
ENV PORT="8080"
ENV NODE_ENV="production"
ENV VAPID_PUBLIC_KEY="BNEalBKv4PPkaCfptTW582JLDjMqQzw6CUM6ZdP3mRMEndhRrkLhtBcwoterpS-n4Bghce1WEPPbVgj-2vOKaxw"
ENV VAPID_PRIVATE_KEY="J6XOwjUQ9qLZpu8WC_srpcoisPTaSSyJE_FpFCI01ng"
# add shortcut for connecting to database CLI
RUN echo "#!/bin/sh\nset -x\nprisma \$PLANETSCALE_PRISMA_DATABASE_URL" > /usr/local/bin/database-cli && chmod +x /usr/local/bin/database-cli

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

COPY ./.pscale/cli-helper-scripts /app/.pscale/cli-helper-scripts
RUN ./.pscale/cli-helper-scripts/create-db-branch-dr-and-connection-pr-branches.sh "$BRANCH_NAME"
COPY ./prisma /app/node_modules/.prisma
CMD ["npm", "start"]

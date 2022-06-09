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

ENV DATABASE_URL=mysql://p1exddxj3evx:pscale_pw_5NxG8YWLIPiXcxlYU5mAneVCEsdOH343oO6eaRJM0Pc@9sjaw7dz29kl.eu-west-3.psdb.cloud/osc-academic-hub?sslaccept=strict
ENV PORT="8080"
ENV NODE_ENV="production"
ENV VAPID_PUBLIC_KEY="BNEalBKv4PPkaCfptTW582JLDjMqQzw6CUM6ZdP3mRMEndhRrkLhtBcwoterpS-n4Bghce1WEPPbVgj-2vOKaxw"
ENV VAPID_PRIVATE_KEY="J6XOwjUQ9qLZpu8WC_srpcoisPTaSSyJE_FpFCI01ng"


# add shortcut for connecting to database CLI
RUN echo "#!/bin/sh\nset -x\nsqlite3 \$DATABASE_URL" > /usr/local/bin/database-cli && chmod +x /usr/local/bin/database-cli

WORKDIR /myapp

COPY --from=production-deps /myapp/node_modules /myapp/node_modules
COPY --from=build /myapp/node_modules/.prisma /myapp/node_modules/.prisma

COPY --from=build /myapp/build /myapp/build
COPY --from=build /myapp/public /myapp/public
ADD . .

CMD ["npm", "start"]

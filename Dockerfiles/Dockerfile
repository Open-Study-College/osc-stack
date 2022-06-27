# base node image
FROM node:16-bullseye-slim as base

RUN npx prisma migrate dev --force

# set for base and all layer that inherit from it
ENV NODE_ENV production
ENV PLANETSCALE_PRISMA_DATABASE_URL='mysql://1n2bdctx2t9o:pscale_pw_Hr2IezBNX7b3wT2Z208Sbpp0Cq-CNPmF1IxavbcjK7c@ttpk5bq1fvyq.us-east-4.psdb.cloud/osc-academic-hub?sslaccept=strict&sslcert=./cacert.pem'
ENV PRISMA_SHADOW_DATABASE_URL='mysql://421p0l2gnxa2:pscale_pw_QWupSicfF_u5kgs9kHZbDCE-L0vvXL78fKB9LA8bmUE@ahhh4agj6mng.us-east-2.psdb.cloud/osc-academic-hub?sslaccept=strict&sslcert=./cacert.pem'
ENV PORT="8080"
ENV NODE_ENV="production"

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

# add shortcut for connecting to database CLI
RUN echo "#!/bin/sh\nset -x\nprisma \$PLANETSCALE_PRISMA_DATABASE_URL" > /usr/local/bin/database-cli && chmod +x /usr/local/bin/database-cli

WORKDIR /myapp

COPY --from=production-deps /myapp/node_modules /myapp/node_modules
COPY --from=build /myapp/node_modules/.prisma /myapp/node_modules/.prisma

COPY --from=build /myapp/build /myapp/build
COPY --from=build /myapp/public /myapp/public

ADD . .

RUN mkdir -p prisma
COPY ./prisma /app/prisma

EXPOSE 3306
EXPOSE 8080

CMD ["npm", "start"]

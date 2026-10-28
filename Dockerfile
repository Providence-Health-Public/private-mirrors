FROM node:22.23.4-alpine3.23 AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

FROM node:22.23.4-alpine3.23 AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NEXT_TELEMETRY_DISABLED=1

RUN npm run build
RUN npm prune --omit=dev

FROM node:22.23.4-alpine3.23 AS runner
LABEL maintainer="@github" \
    org.opencontainers.image.url="https://github.com/github-community-projects/private-mirrors" \
    org.opencontainers.image.source="https://github.com/github-community-projects/private-mirrors" \
    org.opencontainers.image.documentation="https://github.com/github-community-projects/private-mirrors" \
    org.opencontainers.image.vendor="GitHub Community Projects" \
    org.opencontainers.image.description="A GitHub App that allows you

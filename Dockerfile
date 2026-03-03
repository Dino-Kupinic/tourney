FROM oven/bun:1.3.4 AS builder

WORKDIR /app

COPY package.json bun.lock turbo.json ./
COPY apps ./apps
COPY packages ./packages
COPY docs ./docs

RUN bun install --frozen-lockfile

ARG APP_NAME
RUN bun run build --filter=@tourney/${APP_NAME}

FROM oven/bun:1.3.4 AS runner

WORKDIR /app

ARG APP_NAME
ARG APP_PORT

ENV NODE_ENV=production
ENV PORT=${APP_PORT}

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/apps/${APP_NAME}/package.json ./apps/${APP_NAME}/package.json
COPY --from=builder /app/apps/${APP_NAME}/.output ./apps/${APP_NAME}/.output

WORKDIR /app/apps/${APP_NAME}

EXPOSE ${APP_PORT}

CMD ["bun", ".output/server/index.mjs"]

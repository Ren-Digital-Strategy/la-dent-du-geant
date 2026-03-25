FROM node:22-alpine AS base

# Install sharp dependencies for Alpine
RUN apk add --no-cache libc6-compat

RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# Install dependencies
FROM base AS deps
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --frozen-lockfile

# Build the application
FROM base AS builder

# Déclarer les ARG pour les variables d'environnement au build time
ARG DIRECTUS_URL
ARG PUBLIC_DIRECTUS_URL
ARG GOOGLE_PLACES_API_KEY
ARG GOOGLE_PLACE_ID
ARG RESEND_API_KEY
# Les rendre disponibles comme variables d'environnement pendant le build
ENV DIRECTUS_URL=$DIRECTUS_URL
ENV PUBLIC_DIRECTUS_URL=$PUBLIC_DIRECTUS_URL
ENV GOOGLE_PLACES_API_KEY=$GOOGLE_PLACES_API_KEY
ENV GOOGLE_PLACE_ID=$GOOGLE_PLACE_ID
ENV RESEND_API_KEY=$RESEND_API_KEY
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN pnpm run build

# Production image
FROM base AS runner
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=4321

WORKDIR /app

# Copy built assets and production dependencies
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 4321

CMD ["node", "./dist/server/entry.mjs"]

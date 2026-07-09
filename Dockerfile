FROM node:22 AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npx prisma generate

FROM node:22-slim

WORKDIR /app

COPY --from=builder /app .

RUN npm prune --omit=dev

EXPOSE 5000

CMD ["npm", "start"]

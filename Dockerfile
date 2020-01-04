FROM node:lts-alpine as build

WORKDIR /app
COPY package.json package-lock.json /app/
RUN npm ci

COPY . .

CMD ["sh"]

FROM node:lts-alpine
WORKDIR /app

COPY --from=build /app /app

CMD ["sh"]

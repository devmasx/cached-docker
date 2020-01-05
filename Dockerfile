FROM crystallang/crystal as build

WORKDIR /app
COPY shard.yml  /app/
RUN shards install

RUN crystal build src/cached_docker.cr

COPY . .

FROM alpine
WORKDIR /app

COPY --from=build /app/cached_docker /app/cached_docker

ENTRYPOINT [ "cached_docker" ]

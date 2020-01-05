FROM crystallang/crystal:0.32.1 as build

WORKDIR /app
COPY shard.yml  /app/
RUN shards install

COPY . .
RUN crystal build src/cached_docker.cr

CMD ["bash"]

FROM alpine
WORKDIR /app

COPY --from=build /app/cached_docker /app/cached_docker

ENTRYPOINT [ "/app/cached_docker" ]

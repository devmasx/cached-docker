FROM docker:19.03.5 as builder

RUN apk add crystal shards
RUN apk add libevent pcre libgcc musl-dev

WORKDIR /app

COPY shard.yml  /app/
RUN shards install

COPY . .
RUN crystal build src/cached_docker.cr -o /bin/cached-docker

CMD ["sh"]

# ===============================

FROM docker:stable
RUN apk add libevent pcre libgcc

COPY --from=builder /bin/cached-docker /bin/cached-docker

CMD [ "/bin/cached-docker" ]

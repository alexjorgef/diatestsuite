FROM golang:1.19-alpine AS build

RUN apk add --no-cache make gcc musl-dev linux-headers git bash

WORKDIR $GOPATH/src/

COPY ./diadata/cmd/services/filtersBlockService ./
COPY ./diadata/config /config/

RUN go mod tidy && CGO_ENABLED=0 go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/filtersBlockService /bin/filtersBlockService
COPY --from=build /config/ /config/

ENV USE_ENV=true
ENV POSTGRES_USER=d2Vic2l0ZV91c2Vy
ENV POSTGRES_PASSWORD=cGFzcw==
ENV POSTGRES_DB=diadata_psql_db
ENV POSTGRES_HOST=clusterdev-db-postgres-service.default.svc.cluster.local
ENV INFLUXURL=http://clusterdev-db-influx-service.default.svc.cluster.local:8086
ENV INFLUXUSER=diadata_user
ENV INFLUXPASSWORD=diadata_pw
ENV REDISURL=clusterdev-db-redis-service.default.svc.cluster.local:6379
ENV KAFKAURL=clusterdev-db-kafka-service.default.svc.cluster.local:9094

CMD ["filtersBlockService"]
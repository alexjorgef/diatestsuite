FROM golang:1.19-alpine AS build

RUN apk add --no-cache make gcc musl-dev linux-headers git bash

WORKDIR $GOPATH/src/

COPY ./diadata/cmd/services/tradesBlockService ./
COPY ./diadata/config /config/

RUN go mod tidy -go=1.16 && go mod tidy -go=1.17 && CGO_ENABLED=0 go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/tradesBlockService /bin/tradesBlockService
COPY --from=build /config/ /config/

# TODO: this should not be hardcoded
COPY ./secrets/postgres_credentials.txt /src/github.com/diadata-org/diadata/secrets/postgres_credentials.txt

ENV USE_ENV=true
ENV POSTGRES_USER=diadata_psql_user
ENV POSTGRES_PASSWORD=diadata_psql_pass
ENV POSTGRES_DB=diadata_psql_db
ENV POSTGRES_HOST=clusterdev-db-postgres-service.default.svc.cluster.local
ENV INFLUXURL=http://clusterdev-db-influx-service.default.svc.cluster.local:8086
ENV INFLUXUSER=diadata_user
ENV INFLUXPASSWORD=diadata_pw
ENV REDISURL=clusterdev-db-redis-service.default.svc.cluster.local:6379
ENV KAFKAURL=clusterdev-db-kafka-service.default.svc.cluster.local:9094

CMD ["tradesBlockService"]
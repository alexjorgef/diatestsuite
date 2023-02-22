ARG exchange
FROM golang:1.19-alpine AS build

RUN apk add --no-cache make gcc musl-dev linux-headers git bash

WORKDIR $GOPATH/src/

COPY ./diadata/cmd/exchange-scrapers/collector ./
COPY ./diadata/config /config/

RUN go mod tidy && CGO_ENABLED=0 go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/collector /bin/collector
COPY --from=build /config/ /config/

# TODO: this should not be hardcoded
COPY ./secrets/postgres_credentials.txt /src/github.com/diadata-org/diadata/secrets/postgres_credentials.txt

ENV USE_ENV=true
ENV POSTGRES_USER=d2Vic2l0ZV91c2Vy
ENV POSTGRES_PASSWORD=cGFzcw==
ENV POSTGRES_DB=d2Vic2l0ZQ==
ENV POSTGRES_HOST=clusterdev-db-postgres-service.default.svc.cluster.local
ENV INFLUXURL=clusterdev-db-influx-service.default.svc.cluster.local
ENV INFLUXUSER=diadata_user
ENV INFLUXPASSWORD=diadata_pw
ENV REDISURL=clusterdev-db-redis-service.default.svc.cluster.local:6379

CMD ["collector"]

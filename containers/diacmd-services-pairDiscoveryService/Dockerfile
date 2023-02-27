FROM golang:1.19-alpine AS build

RUN apk add --no-cache make gcc musl-dev linux-headers git bash

WORKDIR $GOPATH/src/

COPY ./diadata/cmd/services/pairDiscoveryService ./
COPY ./diadata/config /config/

RUN go mod tidy && CGO_ENABLED=0 go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/pairDiscoveryService /bin/pairDiscoveryService
COPY --from=build /config/ /config/

CMD ["pairDiscoveryService"]
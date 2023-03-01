FROM golang:1.14-alpine AS build

RUN apk add --no-cache make gcc musl-dev linux-headers git bash

WORKDIR $GOPATH/src/

COPY ./diadata/cmd/services/blockchainservice ./
COPY ./diadata/config /config/

RUN go mod tidy && CGO_ENABLED=0 go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/blockchainservice /bin/blockchainservice
COPY --from=build /config/ /config/

# TODO: this should not be hardcoded
COPY ./secrets/postgres_credentials.txt /src/github.com/diadata-org/diadata/secrets/postgres_credentials.txt

CMD ["blockchainservice"]
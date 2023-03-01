ARG exchange
FROM golang:1.19-alpine AS build

RUN apk add --no-cache make gcc musl-dev linux-headers git bash

WORKDIR $GOPATH/src/

# TODO: use parameters to change the branch and the protocol to clone
RUN git clone https://github.com/diadata-org/diadata

RUN cp -r diadata/cmd/exchange-scrapers/collector/* ./
RUN mkdir /config/
RUN cp -r diadata/config/* /config/

RUN go mod tidy && CGO_ENABLED=0 go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/collector /bin/collector
COPY --from=build /config/ /config/

# TODO: this should not be hardcoded
# change diadata-org--diadata/pkg/dia/helpers/db/postgres.go:L90 to use another folder to work with distroless images? or maybe remove this image...
COPY ./secrets/postgres_credentials.txt /src/github.com/diadata-org/diadata/secrets/postgres_credentials.txt

CMD ["collector"]
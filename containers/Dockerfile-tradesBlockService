FROM golang:1.17-alpine AS build

RUN apk add --no-cache make gcc musl-dev linux-headers git bash

WORKDIR $GOPATH/src/

# TODO: use parameters to change the branch and the protocol to clone
RUN git clone https://github.com/diadata-org/diadata

RUN cp -r diadata/cmd/services/tradesBlockService/* ./
RUN mkdir /config/
RUN cp -r diadata/config/* /config/

RUN go mod tidy -go=1.16 && go mod tidy -go=1.17 && CGO_ENABLED=0 go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/tradesBlockService /bin/tradesBlockService
COPY --from=build /config/ /config/

# TODO: this should not be hardcoded
COPY ./secrets/postgres_credentials.txt /src/github.com/diadata-org/diadata/secrets/postgres_credentials.txt

CMD ["tradesBlockService"]
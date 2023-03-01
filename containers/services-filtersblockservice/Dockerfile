FROM golang:1.14-alpine AS build

RUN apk add --no-cache make gcc musl-dev linux-headers git bash

WORKDIR $GOPATH/src/

COPY ./diadata/cmd/services/filtersBlockService ./
COPY ./diadata/config /config/

RUN go mod tidy && CGO_ENABLED=0 go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/filtersBlockService /bin/filtersBlockService
COPY --from=build /config/ /config/

CMD ["filtersBlockService"]
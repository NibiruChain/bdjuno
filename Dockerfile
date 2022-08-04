FROM golang:1.18-alpine AS builder

ARG GIT_TOKEN

RUN apk update && apk add --no-cache make git

RUN go env -w GOPRIVATE=github.com/NibiruChain
RUN git config --global url."https://git:${GIT_TOKEN}@github.com".insteadOf "https://github.com"

WORKDIR /go/src/github.com/forbole/bdjuno
COPY . ./
RUN go mod download
RUN make build

FROM alpine:latest
WORKDIR /bdjuno
COPY --from=builder /go/src/github.com/forbole/bdjuno/build/bdjuno /usr/bin/bdjuno
CMD [ "bdjuno" ]

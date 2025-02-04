FROM golang:1.16-alpine as builder
WORKDIR /app
COPY go.mod .
COPY go.sum .
COPY cmd ./cmd
COPY internal ./internal

ARG TARGETARCH

RUN GOOS=linux GOARCH=$TARGETARCH CGO_ENABLED=0 go build -ldflags="-w -s" -o app cmd/main.go

FROM alpine:3.9.3
RUN apk add --no-cache bash
WORKDIR /app
COPY --from=builder /app/app app
ENTRYPOINT ["/app/app"]

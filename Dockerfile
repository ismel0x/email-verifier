FROM golang:1.22.5-alpine3.20 AS build_image

RUN apk update && apk upgrade && apk add --no-cache bash git openssh

WORKDIR /app

COPY . .

RUN go mod tidy -compat=1.22
RUN go mod download

ENV GOOS=linux GOARCH=amd64

RUN go build -o main ./cmd/apiserver/main.go

FROM alpine:3.16

RUN apk add --no-cache ca-certificates

WORKDIR /root/
COPY --from=build_image /app/main .

EXPOSE 8080

ENTRYPOINT ["./main"]
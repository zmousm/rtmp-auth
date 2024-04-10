FROM golang:1-bullseye AS build
# FROM mcr.microsoft.com/vscode/devcontainers/go:0-1-bullseye

ARG NODE_VERSION="none"

RUN apt-get update \
    && apt-get install -y protobuf-compiler \
    && rm -rf /var/lib/apt/lists/*

RUN export GO111MODULE=on \
    && go install google.golang.org/protobuf/cmd/protoc-gen-go@latest \
        && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest \
        && go install github.com/rakyll/statik@latest

WORKDIR /usr/src/app

COPY . .

RUN make

FROM alpine:latest

COPY --from=build /usr/src/app/rtmp-auth /rtmp-auth

CMD ["/rtmp-auth"]

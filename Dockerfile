# Build stage
FROM alpine:latest as base

WORKDIR /

ARG vs_type=stable
ARG vs_os=linux-x64
ARG vs_version=1.18.15

RUN apk add --no-cache wget \
    && wget -O vs_server.tar.gz "https://cdn.vintagestory.at/gamefiles/${vs_type}/vs_server_${vs_os}_${vs_version}.tar.gz"

# Runtime stage
FROM mcr.microsoft.com/dotnet/sdk:7.0 as runtime

WORKDIR /game
ENV VS_DATA_PATH=/game/data/vs

COPY --from=base "/vs_server.tar.gz" "/game"
RUN tar -xvzf "vs_server.tar.gz" && rm "vs_server.tar.gz"

#  Expose ports
EXPOSE 42420/tcp

# Execution command
CMD dotnet VintagestoryServer.dll --dataPath $VS_DATA_PATH
# Download files
FROM alpine:latest AS downloaded
WORKDIR /downloads

ARG VERSION="latest"
ARG RELEASE_TYPE="stable"

RUN wget "https://cdn.vintagestory.at/gamefiles/${RELEASE_TYPE}/vs_server_${VERSION}.tar.gz"
RUN tar xzf "vs_server_${VERSION}.tar.gz"
RUN rm "vs_server_${VERSION}.tar.gz"

# Run server
FROM mono:latest AS base
WORKDIR /vintagestory

COPY --from=downloaded /downloads /vintagestory

VOLUME [ "/vintagestory/data" ]

EXPOSE 25565/tcp
CMD mono VintagestoryServer.exe --dataPath ./data

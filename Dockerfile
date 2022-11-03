# Download files
FROM alpine:latest AS downloaded
WORKDIR /downloads

ENV DEBIAN_FRONTEND noninteractive

RUN useradd -m -d /home/container container
ENV USER=container HOME=/home/container

RUN apt update && apt upgrade -y

RUN apt install -y gcc g++ libgcc1 lib32gcc1-amd64-cross libc++-dev gdb libc6 git wget curl tar zip unzip binutils xz-utils liblzo2-2 cabextract iproute2 net-tools netcat telnet libatomic1 libsdl1.2debian libsdl2-2.0-0 \
        libfontconfig libicu60 libiculx60 icu-devtools libunwind8 libssl1.0.0 libssl1.0-dev sqlite3 libsqlite3-dev libmariadbclient-dev libduktape202 libzip4 locales ffmpeg apt-transport-https init-system-helpers \
        libcurl3-gnutls libjsoncpp1 libleveldb1v5 liblua5.1-0 libluajit-5.1-2 libsqlite3-0 libfluidsynth1 bzip2 zlib1g libevent-dev mono-complete

RUN update-locale lang=en_US.UTF-8 \
 && dpkg-reconfigure --frontend noninteractive locales

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

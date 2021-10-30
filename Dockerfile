FROM debian:buster as build
RUN apt update && apt install -y \
      librtlsdr-dev build-essential git zlib1g-dev libncurses-dev libxml2-dev libtecla-dev libusb-1.0.0-dev pkg-config && \
      rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/Mictronics/readsb.git && cd readsb && \
      make -j RTLSDR=yes

FROM debian:buster-slim
RUN apt update && apt install -y \
      librtlsdr0 libncurses6 libxml2 libusb-1.0.0 bc jq dumb-init && \
      rm -rf /var/lib/apt/lists/*

COPY --from=build /readsb/readsb /readsb/viewadsb /usr/local/bin/
COPY run.sh healthcheck.sh /

ENTRYPOINT ["/run.sh"]

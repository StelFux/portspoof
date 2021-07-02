FROM docker.io/library/alpine:latest AS build

WORKDIR /build
COPY . /build

RUN apk add --no-cache make g++ linux-headers && \ 
	sed -i "s#sys/sysctl.h#linux/sysctl.h#g" src/connection.h && \
	./configure --sysconfdir=/etc/ --prefix=/ CXXFLAGS="-static -s" && \
	make


FROM scratch 
COPY --from=build /build/src/portspoof /

ENTRYPOINT ["/portspoof"]

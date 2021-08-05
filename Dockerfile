ARG ARCH=arm64v8
FROM mcharo/archlinux-$ARCH:latest-base

WORKDIR /archlinux

RUN mkdir -p /archlinux/rootfs

COPY pacstrap-docker /archlinux/

RUN ./pacstrap-docker /archlinux/rootfs \
	    bash sed gzip pacman && \
    # Remove current pacman database, likely outdated very soon
    rm rootfs/var/lib/pacman/sync/*

FROM scratch
ARG ARCH=arm64v8

COPY --from=0 /archlinux/rootfs/ /
COPY rootfs/common/ /
COPY rootfs/$ARCH/ /

ENV LANG=en_US.UTF-8

RUN locale-gen && \
    pacman-key --init && \
    (pacman-key --populate archlinuxarm || pacman-key --populate archlinux)

CMD ["/usr/bin/bash"]

FROM ubuntu:12.04

MAINTAINER Ferenc Horváth <hferenc@inf.u-szeged.hu>

ENV ARCH x86_64
ENV CIRROS_VER 0.3.4

RUN apt-get update && apt-get install -y \
	bison \
	build-essential \
	bzr \
	flex \
	gettext \
	ncurses-dev \
	qemu-kvm \
	quilt \
	rsync \
	texinfo \
	unzip \
	wget

RUN mkdir /root/build /root/source

RUN wget https://launchpad.net/ubuntu/+archive/primary/+files/linux-image-3.2.0-80-generic_3.2.0-80.116_amd64.deb -O /root/source/linux-image-3.2.0-80-generic_3.2.0-80.116_amd64.deb

RUN ( wget http://download.cirros-cloud.net/$CIRROS_VER/cirros-$CIRROS_VER-source.tar.gz -O /root/source/cirros-$CIRROS_VER-source.tar.gz && tar -xf /root/source/cirros-$CIRROS_VER-source.tar.gz -C /root/build )

RUN echo "i6300esb heartbeat=2 nowayout=1" >> /root/build/cirros-$CIRROS_VER/src/etc/modules

RUN ( wget http://download.cirros-cloud.net/$CIRROS_VER/buildroot_rootfs/buildroot-$CIRROS_VER-$ARCH.tar.gz -O /root/source/buildroot-$CIRROS_VER-$ARCH.tar.gz && gunzip /root/source/buildroot-$CIRROS_VER-$ARCH.tar.gz )

CMD ( cd /root/build/cirros-$CIRROS_VER && ./bin/bundle -v --arch=$ARCH /root/source/buildroot-$CIRROS_VER-$ARCH.tar /root/source/linux-image-3.2.0-80-generic_3.2.0-80.116_amd64.deb output/$ARCH/images )

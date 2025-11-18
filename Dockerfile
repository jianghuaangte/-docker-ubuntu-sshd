FROM ubuntu:24.04
MAINTAINER "jianghuaangte"

# timezone
RUN apt update && apt install -y tzdata locales; \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    dpkg-reconfigure --frontend noninteractive tzdata; \
    locale-gen zh_CN.UTF-8; \
    update-locale LANG=zh_CN.UTF-8; \
    apt clean;

# sshd
RUN mkdir /run/sshd; \
    apt install -y openssh-server; \
    sed -i 's/^#\(PermitRootLogin\) .*/\1 yes/' /etc/ssh/sshd_config; \
    sed -i 's/^\(UsePAM yes\)/# \1/' /etc/ssh/sshd_config; \
    apt clean;

# entrypoint
RUN { \
    echo '#!/bin/bash -eu'; \
    echo 'ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime'; \
    echo 'echo "root:${ROOT_PASSWORD}" | chpasswd'; \
    echo 'exec "$@"'; \
    } > /usr/local/bin/entry_point.sh; \
    chmod +x /usr/local/bin/entry_point.sh;

ENV TZ Asia/Shanghai

ENV ROOT_PASSWORD root

EXPOSE 22

ENTRYPOINT ["entry_point.sh"]
CMD    ["/usr/sbin/sshd", "-D", "-e"]

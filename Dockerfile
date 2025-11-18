FROM ubuntu:22.04

# 设置时区和安装中文环境包
RUN apt update && apt install -y \
    tzdata \
    language-pack-zh-hans \
    locales \
    openssh-server \
    sudo \
    && locale-gen zh_CN.UTF-8 \
    && update-locale LANG=zh_CN.UTF-8 \
    && echo "LANG=zh_CN.UTF-8" > /etc/default/locale \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 设置中文环境
ENV TZ=Asia/Shanghai
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8
ENV ROOT_PASSWORD=root
ENV USERNAME=user
ENV USER_PASSWORD=userpassword

# 设置 sshd
RUN mkdir /run/sshd && \
    sed -i 's/^#\(PermitRootLogin\) .*/\1 yes/' /etc/ssh/sshd_config && \
    sed -i 's/^\(UsePAM yes\)/# \1/' /etc/ssh/sshd_config

# 创建普通用户并设置密码
RUN useradd -m -s /bin/bash ${USERNAME} && \
    echo "${USERNAME}:${USER_PASSWORD}" | chpasswd && \
    adduser ${USERNAME} sudo

# 设置 entrypoint 脚本
RUN { \
    echo '#!/bin/bash -eu'; \
    echo 'ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime'; \
    echo 'echo "root:${ROOT_PASSWORD}" | chpasswd'; \
    echo 'exec "$@"'; \
    } > /usr/local/bin/entry_point.sh && \
    chmod +x /usr/local/bin/entry_point.sh

# 设置暴露端口
EXPOSE 22

# 设置默认命令
ENTRYPOINT ["entry_point.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e"]

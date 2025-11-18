FROM ubuntu:24.04

# Maintainer
LABEL maintainer="Hiroki Takeyama"

# ------------------------------
# Set timezone and install packages
# ------------------------------
RUN apt update && apt install -y \
    tzdata \
    language-pack-en \
    locales \
    openssh-server \
    sudo \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && echo "LANG=en_US.UTF-8" > /etc/default/locale \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------
# Environment variables
# ------------------------------
ENV TZ=Asia/Shanghai
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV ROOT_PASSWORD=root
ENV USERNAME=user
ENV USER_PASSWORD=userpassword

# ------------------------------
# Setup SSH
# ------------------------------
RUN mkdir /run/sshd && \
    sed -i 's/^#\(PermitRootLogin\) .*/\1 yes/' /etc/ssh/sshd_config && \
    sed -i 's/^\(UsePAM yes\)/# \1/' /etc/ssh/sshd_config

# ------------------------------
# Setup entrypoint script
# ------------------------------
RUN { \
    echo '#!/bin/bash -eu'; \
    echo ''; \
    echo '# Set timezone'; \
    echo 'ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime'; \
    echo ''; \
    echo '# Set root password'; \
    echo 'echo "root:${ROOT_PASSWORD}" | chpasswd'; \
    echo ''; \
    echo '# Create normal user if not exists'; \
    echo 'if ! id -u "${USERNAME}" >/dev/null 2>&1; then'; \
    echo '    useradd -m -s /bin/bash "${USERNAME}"'; \
    echo '    echo "${USERNAME}:${USER_PASSWORD}" | chpasswd'; \
    echo '    adduser "${USERNAME}" sudo'; \
    echo 'fi'; \
    echo ''; \
    echo 'exec "$@"'; \
    } > /usr/local/bin/entry_point.sh && \
    chmod +x /usr/local/bin/entry_point.sh

# ------------------------------
# Expose SSH port
# ------------------------------
EXPOSE 22

# ------------------------------
# Set default command
# ------------------------------
ENTRYPOINT ["/usr/local/bin/entry_point.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e"]

# ubuntu-sshd

## How to use
This container can be accessed by SSH and SFTP clients.

    docker run -d --name ubuntu-sshd \  
           -e TZ=Asia/Shanghai \  
           -e ROOT_PASSWORD=root \  
           -p 8022:4022 \  
           freedomzzz/docker-ubuntu-sshd

You can add extra ports and volumes as follows if you want.

    docker run -d --name ubuntu-sshd \  
           -e TZ=Asia/Shanghai \  
           -e ROOT_PASSWORD=root \  
           -p 8022:4022 \  
           -p 8080:80 \  
           -v /my/own/datadir:/var/www/html \  
           freedomzzz/docker-ubuntu-sshd



```yml
version: '3'
services:
  my_ubuntu_container:
    image: freedomzzz/docker-ubuntu-sshd:latest
    container_name: ubuntu-sshd
    ports:
      - "4022:4022"  # 默认端口4022
    environment:
      - ROOT_PASSWORD=123456
      - USERNAME=ll
      - USER_PASSWORD=123456
#    volumes:
#      - ./data:/data  # 可选，如果你需要挂载宿主机目录到容器中
    restart: unless-stopped  # 容器失败时重启
```

SCP command can be used for transferring files.

    scp -P 8022 -r /my/own/apache2.conf root@localhost:/etc/apache2/apache2.conf

## Time zone
You can use any time zone such as America/Chicago that can be used in Ubuntu.  

See below for zones.  
https://www.unicode.org/cldr/charts/latest/verify/zones/en.html

## Logging
This container logs the beginning, authentication, and termination of each connection.  
Use the following command to view the logs in real time.

    docker logs -f ubuntu-sshd

# ubuntu-sshd

## How to use
This container can be accessed by SSH and SFTP clients.

    docker run -d --name ubuntu-sshd \  
           -e TZ=Asia/Tokyo \  
           -e ROOT_PASSWORD=root \  
           -p 8022:22 \  
           freedomzzz/docker-ubuntu-sshd

You can add extra ports and volumes as follows if you want.

    docker run -d --name ubuntu-sshd \  
           -e TZ=Asia/Shanghai \  
           -e ROOT_PASSWORD=root \  
           -p 8022:22 \  
           -p 8080:80 \  
           -v /my/own/datadir:/var/www/html \  
           freedomzzz/docker-ubuntu-sshd

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

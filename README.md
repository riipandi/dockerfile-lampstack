# Linux Web Development Stack

This is a docker images with Debian Stable with _apache2_ and _php7/composer_
To access site contents from outside the container you should map _/var/www_

**Examples**
- Plain, accessable on port 8080
```docker run -d -p 8080:80 riespandi/lampstack```
- With external contents in _/home/ariss/html_
```docker run -d -p 8080:80 -v /home/ariss/html:/var/www/html riespandi/lampstack```

The docker container is started with the -d flag so it will run inte the background. 
To run commands or edit settings inside the container run:

```docker exec -ti <container id> /bin/bash```

This repository ready for develop PHP Application such as CodeIgniter, Laravel, WordPress, etc. 
Already included Composer. Can be used for [Oracle Wercker](https://wercker.com/) auto deployment tool.

**Ingredients:**
- Apache HTTP Server
- MariaDB 10
- PHP 7.2

Node Express Server + Mysql
===========================


Usage
-----

### Startup

1. Based on box  [https://github.com/mattandersen/vagrant-lamp/releases](https://github.com/mattandersen/vagrant-lamp/releases)
2. Extract the ZIP file.
3. From the command-line:

```
$ cd vagrant-lamp-release
$ vagrant up
```
That is pretty simple.


#### Nginx

Every process by Node is proxy by nginx, at localhost:80

Technical Details
-----------------
* Ubuntu 14.04 64-bit
* Nginx
* PHP 5.5
* MySQL 5.5
* Nodejs

Every process is mounted in shared folders on host machine.

```
$ vagrant ssh
```

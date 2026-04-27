#!/bin/sh

sestatus

cat /etc/selinux/config

sudo dnf install httpd -y

sudo systemctl enable --now httpd

curl localhost

echo "Test HTML file" > ~/index.html

sudo mv ~/index.html /var/www/html/

curl localhost

ls -lZ /var/www/html/index.html

sudo ausearch -m AVC -ts recent

sudo dnf install setroubleshoot-server -y

sudo sealert --analyze /var/log/audit/audit.log

sudo semanage fcontext --list | grep '/var/www(/.*)?'

sudo restorecon -Rv /var/www/html

curl localhost

echo "Solved module called module-02" >> /tmp/progress.log

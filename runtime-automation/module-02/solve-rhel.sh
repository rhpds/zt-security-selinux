#!/bin/sh

sestatus

cat /etc/selinux/config

sudo dnf install httpd -y

# Ensure mod_ssl has non-empty PEM files at the paths ssl.conf references.
# Some images ship 0-byte placeholder files; httpd refuses to start without real content.
CERT=/etc/pki/tls/certs/localhost.crt
KEY=/etc/pki/tls/private/localhost.key
if [ ! -s "$CERT" ] || [ ! -s "$KEY" ]; then
  sudo mkdir -p /etc/pki/tls/certs /etc/pki/tls/private
  sudo rm -f "$CERT" "$KEY"
  if sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout "$KEY" -out "$CERT" \
    -subj '/CN=localhost' \
    -addext 'subjectAltName=DNS:localhost' 2>/dev/null; then :
  else
    sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
      -keyout "$KEY" -out "$CERT" -subj '/CN=localhost'
  fi
  sudo chmod 600 "$KEY"
  sudo chmod 644 "$CERT"
fi

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

#!/bin/bash
USER=rhel

echo "Adding wheel" > /root/post-run.log
usermod -aG wheel rhel

echo "Setup vm control01" > /tmp/progress.log

chmod 666 /tmp/progress.log

# Ensure mod_ssl has non-empty PEM files at the paths ssl.conf references.
# Some images ship 0-byte placeholder files; httpd refuses to start without real content.
CERT=/etc/pki/tls/certs/localhost.crt
KEY=/etc/pki/tls/private/localhost.key
if [ ! -s "$CERT" ] || [ ! -s "$KEY" ]; then
  command -v openssl >/dev/null 2>&1 || dnf install -y openssl
  mkdir -p /etc/pki/tls/certs /etc/pki/tls/private
  rm -f "$CERT" "$KEY"
  if openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout "$KEY" -out "$CERT" \
    -subj '/CN=localhost' \
    -addext 'subjectAltName=DNS:localhost' 2>/dev/null; then :
  else
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
      -keyout "$KEY" -out "$CERT" -subj '/CN=localhost'
  fi
  chmod 600 "$KEY"
  chmod 644 "$CERT"
  echo "localhost TLS material generated" >> /root/post-run.log
fi

#dnf install -y nc

# Epel
#dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm
# certbot if needed
#dnf install -y certbot

# Enable cockpit functionality in showroom.
#dnf -y remove tlog cockpit-session-recording
#echo "[WebService]" > /etc/cockpit/cockpit.conf
#echo "Origins = https://cockpit-${GUID}.${DOMAIN}" >> /etc/cockpit/cockpit.conf
#echo "AllowUnencrypted = true" >> /etc/cockpit/cockpit.conf
#systemctl enable --now cockpit.socket

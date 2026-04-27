#!/bin/sh

getenforce | grep -qE 'Enforcing|Permissive' && echo "SELinux: PASS" || echo "SELinux: FAIL"

grep -q "Test HTML file" ~/index.html && echo "~/index.html: PASS" || echo "~/index.html: FAIL"

grep -q "Test HTML file" /var/www/html/index.html && echo "/var/www/html/index.html: PASS" || echo "/var/www/html/index.html: FAIL"

curl -s localhost | grep -q "Test HTML file" && echo "curl localhost: PASS" || echo "curl localhost: FAIL"

echo "Validated module called module-02" >> /tmp/progress.log

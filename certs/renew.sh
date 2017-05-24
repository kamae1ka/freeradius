#!/bin/bash
function print-bar()
{
    echo "
==================
$@
==================
Press <Enter> to continue"
    read
}
cd /etc/raddb/certs
print-bar "this script assumes all passwords are the same, this is viable for a restricted area LAN at best. you will be prompted for a password (in all future cases - use the same one)."
echo "removing previous certs"
rm -f *.pem *.der *.csr *.crt *.key *.p12 serial* index.txt*
echo -n Password:
read -s password
for f in $(ls *.cnf); do
    sed -i "s/input_password =[[:blank:]]*$/input_password = $password/g" $f
    sed -i "s/output_password =[[:blank:]]*$/output_password = $password/g" $f
done
echo "rebuilding certs"
./bootstrap
for f in $(ls *.cnf); do
    git checkout -- $f
done
print-bar "before start/restarting radius, update the clients.conf and add [certprivkey = <password>]"

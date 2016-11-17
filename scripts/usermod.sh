names=`awk -F':' -v "limit=1000" '{ if ( $3 >= limit ) print $1}' /etc/passwd`
for name in $names
do
    usermod -a -G uucp,lock,dialout $name
done

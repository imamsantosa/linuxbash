echo -n "masukan nama domain = "; read namadomain;
echo -n "masukan nama user = "; read namauser;
echo -n "masukan password user = "; read passworduser;

#create new user.

useradd -d /var/www/$namadomain $namauser;
echo "berhasil membuat user";

#change passwod
echo $namauser:$passworduser | chpasswd;

echo "berhasil mengubah password";

#create directory 
mkdir -p /var/www/$namadomain/public_html;
echo "berhasil membuat directory";

#change owner directory
chown -R $namauser:$namauser /var/www/$namadomain/public_html;
echo "berhasil mengubah owner directory";

#change chmod 
chmod -R 755 /var/www;
echo "sukses chmod 755";

touch /var/www/$namadomain/public_html/index.php;
echo "<?php echo phpinfo(); ?>" >> /var/www/$namadomain/public_html/index.php;

#create virtual host conf
touch /etc/apache2/sites-available/$namadomain.conf;
apachepath=/etc/apache2/sites-available;

#you can change server Admin to your
echo "<VirtualHost *:80>" >> $apachepath/$namadomain.conf;
echo     "ServerAdmin santosa.web.id" >> $apachepath/$namadomain.conf;
echo     "ServerName  "$namadomain >> $apachepath/$namadomain.conf;
echo     "ServerAlias www."$namadomain >> $apachepath/$namadomain.conf;
echo     "DocumentRoot /var/www/"$namadomain"/public_html" >> $apachepath/$namadomain.conf;
echo	 "ErrorLog "${APACHE_LOG_DIR}"/error.log" >> $apachepath/$namadomain.conf;
echo	 "CustomLog "${APACHE_LOG_DIR}"/access.log combined" >> $apachepath/$namadomain.conf;
echo "</VirtualHost>" >> $apachepath/$namadomain.conf;

echo "sukses membuat virtual host";

#registering vhost to apache2
a2ensite $namadomain.conf;

#adding hosts
echo "192.168.1.5	"$namadomain >> /etc/hosts;
echo "172.0.0.1		"$namadomain >> /etc/hosts;
echo "sukses mengedit hosts file";

#apache restart
service apache2 restart;

echo "sukses membuat domain "$namadomain" dengan user "$namauser" dan password "$passworduser;

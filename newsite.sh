#!/bin/bash
#Requeriments Git, Nginx, php5-fpm
#Version 0.1.2
#Author: Jhonn willker
#Url: https://github.com/JohnWillker/newsite

echo Creating...

#Create a directory for $1 site
mkdir -p /var/www/$1/html

#changing the ownership of these two directories to the regular user.
sudo chown -R $USER:$USER /var/www/$1/html
sudo chmod -R 755 /var/www/$1/html

block="server {
	listen 80;
	listen [::]:80;

	root /var/www/$1/html;
	index index.php index.html index.htm;

	# Make site accessible from http://localhost/
	server_name $1 www.$1;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files \$uri \$uri/ /index.php;
		# Uncomment to enable naxsi on this location
		# include /etc/nginx/naxsi.rules
	}
	#Specify a charset
    charset utf-8;

	error_page 404 /404.html;
	error_page 500 502 503 504 /50x.html;
	location = /50x.html {
		root /var/www/$1/html;
	}

	location ~ \.php$ {
		try_files \$uri =404;
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		fastcgi_pass unix:/var/run/php5-fpm.sock;
		fastcgi_index index.php;
		include fastcgi_params;
	}

	# Only for nginx-naxsi used with nginx-naxsi-ui : process denied requests
	#location /RequestDenied {
	#	proxy_pass http://127.0.0.1:8080;
	#}


	# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
	#
	location ~ \.php$ {
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		# NOTE: You should have \"cgi.fix_pathinfo = 0;\"in php.ini

		# With php5-cgi alone:
		fastcgi_pass 127.0.0.1:9000;
		# With php5-fpm:
		fastcgi_pass unix:/var/run/php5-fpm.sock;
		fastcgi_index index.php;
		include fastcgi_params;
	}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	location ~ /\.ht {
		deny all;
	}
}


# HTTPS server
#
#server {
#	listen 443;
#	server_name localhost;
#
#	root html;
#	index index.html index.htm;
#
#	ssl on;

#	ssl_certificate cert.pem;
#	ssl_certificate_key cert.key;
#
#	ssl_session_timeout 5m;
#
#	ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;
#	ssl_ciphers \"HIGH:!aNULL:!MD5 or HIGH:!aNULL:!MD5:!3DES\";
#	ssl_prefer_server_ciphers on;
#
#	location / {
#		try_files \$uri \$uri/ =404;
#	}
#}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/$1
service nginx restart
service php5-fpm restart

echo
echo Create dir. OK
echo
echo Creating Git integrantion..

#create the dir. of repos.
sudo mkdir -p /var/repo/$1.git
#Permisions
sudo chown -R $USER:$USER /var/repo/$1.git
sudo chmod -R 755 /var/repo/$1.git

cd /var/repo/$1.git
# --baremeans that our folder will have no source files, just the version control.
git init --bare

cd hooks
touch post-receive
#Sync file
echo "#!/bin/sh
git --work-tree=/var/www/$1/html --git-dir=/var/repo/$1.git checkout -f" > "post-receive"

sudo chmod +x post-receive
cd ~/
echo
echo READY!

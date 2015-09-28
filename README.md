##Overview
Script for set configs on server for add new website with NGINX block serve and deploy using Git.

##Requeriments on your server:
- Git
- Nginx
- php5-fpm

##Requeriments on your host:
- Git

####How to use
Copy newsite.sh file to your server and run.

Example:

Copy with scp: `scp newsite.sh user@serverdomain:~/`

Permissions: `sudo chmod +x newsite.sh`

Execute: `./newsite.sh mypage.com or sudo bash newsite.sh mypage.com`

####What happened ?

This script will creat a directory named repo in /var/repo, where git will get the files for sync with directory /var/www/<name of your domain>/html, exactly where Nginx see the files.

####On wour local machine:
```
cd /my/workspace
mkdir project && cd project
git init
git remote add live ssh://user@severdomain.com/var/repo/mypage.com.git
git add .
git commit -m "My site project is ready"
git push live master
```
Your server now set to deploy with Git! :smiley:

##Contributing
Contributions, questions and comments are all welcome and encouraged.

##License
GNU GENERAL PUBLIC LICENSE
Version 2, June 1991

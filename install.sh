#!/bin/bash

sudo apt update
sudo apt install apache2 unzip -y 
cd /tmp/ && wget https://www.free-css.com/assets/files/free-css-templates/download/page295/kider.zip
unzip kider.zip
sudo mv preschool-website-template /var/www/html/preschool
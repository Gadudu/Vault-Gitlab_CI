#!/bin/bash

sudo systemctl install openssl

read -p "enter key/certificate name " name

openssl genpkey -algorithm RSA -out $name.key
sudo openssl req -new -key $name.key -out $name.csr -config san.conf
sudo openssl x509 -req -days 3650 -in $name.csr -signkey $name.key -out $name.crt -extfile san.conf -extensions v3_req


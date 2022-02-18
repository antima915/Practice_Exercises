#!/bin/bash

echo "Enter Your UserName:"
read username

# Adding a User
sudo useradd $username

echo "Enter Your Password:"
#Adding password 
sudo passwd $username
#!/bin/bash

echo "Enter Your UserName:"
read username

# Adding a User
sudo useradd $username

echo "Enter Your Password:"
#Adding password 
sudo passwd $username

#Adding User to a Group
echo "Do you want to get added in a group:"
read option
if [[ $option == "Y" || $option == "y" ]];
then
    echo "The available groups are -- innogeeks, innodemo, Select one:"
    read group

    case $group in 
        "innogeeks" )
            sudo usermod -a -G innogeeks $username
            echo "You are added to innogeeks group " ;;
        "innodemo")
            sudo usermod -a -G innodemo $username
            echo "You are added to innodemo group " ;;
        * )
            echo "Group not Available!! " ;;

    esac
else
    echo "Ok,we won't add you to any group"
fi
        
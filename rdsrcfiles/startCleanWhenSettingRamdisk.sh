#! /bin/bash

function startCleanRamdisk {
    findServiceCommand

    if [[ $SERVICECMD == "systemctl" ]]; then
	echo "sudo systemctl stop mysqld"
	sudo systemctl stop mysqld
    elif [[ $SERVICECMD == "service" ]]; then
	echo "sudo service mysql stop"
	sudo service mysql stop
    else
	echo "Unsupport service stop command"
	exit
    fi

    sudo umount /mnt/ramdisk

    sudo mount -t tmpfs -o size=8192m tmpfs /mnt/ramdisk
    sudo mysql_install_db --user=mysql --datadir=/mnt/ramdisk/
    sudo chown -R mysql:mysql /mnt/ramdisk

    if [[ $SERVICECMD == "systemctl" ]]; then
	echo "sudo systemctl start mysqld"
	sudo systemctl start mysqld
    elif [[ $SERVICECMD == "service" ]]; then
	echo "sudo service mysql start"
	sudo service mysql start
    else
	echo "Unsupport service stop command"
	exit
    fi

    echo "create database v4ramdisk character set utf8 collate utf8_bin;" | mysql -u root
    #echo "grant all privileges on *.* to 'v4'@'%' identified by 'v4';" | mysql -u root
    #echo "flush privileges;" | mysql -u root
    mysql -u root mysql < $HOME/ramdisk/tzdata.sql

    echo "Database is ready to use :)"
}


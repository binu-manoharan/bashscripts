#!/bin/bash

function setUpRamDisk {
    echo
    echo "Setting up ramdisk for mysql"
    echo

    findServiceCommand
    
    #This method always needs to be called first to initialised $RAMDISKDIR
    createRamDiskDir

    moveRamdiskRelatedFiles

    if [[ $SERVICECMD == "service" ]]; then
	#Only needed on ubuntu - service start relies on /etc/mysql/my.cnf to have the
	#right. Ubuntu comes with AppArmor (Security stuff) which has usr.sbin.mysqld
	#which needs changes as well.

	createMysqlBackUpDir
	
	createMysqlCnfFiles

	makeAppArmorChanges
    fi
}

function createMysqlBackUpDir {
    if [[ -d $RAMDISKDIR/backup ]]; then
	echo "Backup directory exist.. not creating."
    else
	echo "Make back up directory"
	echo "mkdir -p $RAMDISKDIR/backup"
	mkdir -p $RAMDISKDIR/backup
    fi
}

function moveRamdiskRelatedFiles {
    if [[ $(ls -A $RAMDISKDIR) ]]; then
	echo "$RAMDISKDIR is not empty!! Aborting."
	exit
    else
	echo "sudo cp ./rdsrcfiles/startCleanRamdisk.sh $RAMDISKDIR"
	sudo cp ./rdsrcfiles/startCleanRamdisk.sh $RAMDISKDIR

	echo "sudo cp ./rdsrcfiles/checkInitServiceCommand.sh $RAMDISKDIR"
	sudo cp ./rdsrcfiles/checkInitServiceCommand.sh $RAMDISKDIR

	echo "sudo mysql_tzinfo_to_sql /usr/share/zoneinfo > $RAMDISKDIR/tzdata.sql"
	sudo mysql_tzinfo_to_sql /usr/share/zoneinfo > $RAMDISKDIR/tzdata.sql
    fi
}

function createRamDiskDir {
    RAMDISKDIR="$HOME/ramdisk"
    RAMDISKMOUNTDIR="/mnt/ramdisk"

    if [[ -d $RAMDISKMOUNTDIR ]]; then
	echo "Mount directory ($RAMDISKMOUNTDIR) exists.. Not creating"
    else
	echo "Creating mount directory /mnt/ramdisk"
	sudo mkdir -p /mnt/ramdisk

	echo "Updating owner for $RAMDISKMOUNTDIR"
	sudo chown -R mysql:mysql $RAMDISKMOUNTDIR
    fi
    
    if [[ -d $RAMDISKDIR ]]; then
	echo "$RAMDISKDIR exists.. Not creating"
    else
	echo "$RAMDISKDIR does not exist.. Creating new.."
	mkdir $RAMDISKDIR
    fi
}

function createMysqlCnfFiles {
    #Removed if not needed on ubuntu
    local mysqlcnf="/etc/mysql/my.cnf"
    local backupdate=`date +%Y%m%d%H%M`
    local ramdiskmycnf=$RAMDISKDIR/my.cnf_ramdisk
    
    echo "Checking for current mysql config file in $mysqlcnf"
    
    if [[ -a $mysqlcnf ]]; then
	echo "sudo cp $mysqlcnf $RAMDISKDIR"
	sudo cp $mysqlcnf $RAMDISKDIR
	
	echo "Backing up existing my.cnf in $RAMDISKDIR/my.cnf_$backupdate"
	sudo cp $RAMDISKDIR/my.cnf $RAMDISKDIR/backup/my.cnf_$backupdate

	echo "Creating new my.cnf for use by ramdisk -> $ramdiskmycnf & updating data directory"
	sudo mv $RAMDISKDIR/my.cnf $ramdiskmycnf

	echo "sudo chmod 777 $ramdiskmycnf"
	sudo chmod 777 $ramdiskmycnf

	echo "sudo sed -i 's/datadir/#datadir/g' $ramdiskmycnf"
	sudo sed -i 's/datadir/#datadir/g' $ramdiskmycnf

	echo "sudo echo \"datadir = /mnt/ramdisk\" >> $ramdiskmycnf"
	sudo echo "datadir = /mnt/ramdisk" >> $ramdiskmycnf

	echo
	echo "Diff in mysql new my.cnf vs current my.cnf"
	diff $ramdiskmycnf $mysqlcnf

	echo "Updating mysql cnf file"
	echo "sudo cp $ramdiskmycnf $mysqlcnf"
	sudo cp $ramdiskmycnf $mysqlcnf

	echo "Copying new settings to /usr to work around a known mysql bug"
	echo "sudo cp $ramdiskmycnf /usr/my-default.cnf"
	sudo cp $ramdiskmycnf /usr/my-default.cnf
 
    else
	echo "mysql config file missing from /etc/mysql/my.cnf"
	exit
    fi
}

function makeAppArmorChanges {
    local apparmormysqlfile="/etc/apparmor.d/usr.sbin.mysqld"
    
    if [[ -a $apparmormysqlfile ]]; then
	local backupdate=`date +%Y%m%d%H%M`

	echo "sudo cp $apparmormysqlfile $RAMDISKDIR/backup/usr.sbin.mysqld_$backupdate"
	sudo cp $apparmormysqlfile $RAMDISKDIR/backup/usr.sbin.mysqld_$backupdate

	echo "Updating $apparmormysqlfile"
	sudo sed -i 's/}/QWERTYUIOP\n}/' $apparmormysqlfile
	sudo sed -i 's/}/ASDFGHJKL\n}/' $apparmormysqlfile

	sudo sed -i 's/QWERTYUIOP/\/mnt\/ramdisk\/ r,/' $apparmormysqlfile
	sudo sed -i 's/ASDFGHJKL/\/mnt\/ramdisk\/** rwk,/' $apparmormysqlfile
    fi
}

#!/bin/bash

function setUpRamDisk {
    echo
    echo "Setting up ramdisk for mysql"
    echo

    #This method always needs to be called first to initialised $RAMDISKDIR
    createRamDiskDir

    #    createMysqlCnfFiles --might be needed on ubuntu

    moveRamdiskRelatedFiles
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
	
	echo "Backing up existing my.cnf in $RAMDISK/my.cnf_$backupdate"
	sudo cp $RAMDISKDIR/my.cnf $RAMDISKDIR/my.cnf_$backupdate

	echo "Creating new my.cnf for use by ramdisk -> $ramdiskmycnf & updating data directory"
	sudo mv $RAMDISKDIR/my.cnf $ramdiskmycnf
	sudo sed -i 's/datadir/#datadir/g' $ramdiskmycnf
	sudo echo "datadir = /mnt/ramdisk" >> $ramdiskmycnf

	echo
	echo "Diff in mysql new my.cnf vs current my.cnf"
	diff $ramdiskmycnf $mysqlcnf

	echo "Updating mysql cnf file"
	echo "sudo cp $ramdiskmycnf $mysqlcnf"
	sudo cp $ramdiskmycnf $mysqlcnf
    else
	echo "mysql config file missing from /etc/mysql/my.cnf"
	exit
    fi
}


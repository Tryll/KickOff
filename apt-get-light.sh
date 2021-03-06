#!/bin/sh
#
#	APT-GET-LIGHT - a Debian package manager for embedded devices by Tryll
#	Supports: update, info, resolve, download and install
#
#	Copyright (c) 2020
#	Tryll AS <info@tryll.com>
#	All rights reserved.
#	
#	==============================================================================
#	
#	This file is part of KickOff
#	KickOff is free software: you can redistribute it and/or modify it
#	under the terms of the GNU General Public License as published by
# 	the Free Software Foundation, either version 3 of the License, or
# 	(at your option) any later version.
# 	This program is distributed in the hope that it will be useful, but
# 	WITHOUT ANY WARRANTY; without even the implied warranty of
# 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# 	General Public License for more details.
# 	You should have received a copy of the GNU General Public License
# 	along with this program.  If not, see <http://www.gnu.org/licenses/>.
#	==============================================================================
# 
#
# 	Todo
# 	1. Replace DISTOR/ARCH logic with /etc/apt/sources.list support, overideable by an APTSource variable
#	2. Skip redownloading files that pass md5sum
#

# DISTRO CHECK:
if [ -z $DISTRO ] && [ -z $ARCH ]; then
        echo APT: DISTRO and/or ARCH not defined
        exit 1
fi

SOURCE="http://deb.debian.org/debian/"
PACKAGES=/tmp/$DISTRO-$ARCH-packages

if [ ! -f "$PACKAGES" ] || [ "$1" = "update" ]; then
        echo APT: Downloading packages overview for $DISTRO $ARCH.
        wget -qO- $SOURCE/dists/$DISTRO/main/binary-$ARCH/Packages.gz | gunzip > $PACKAGES
	
	if [ "$1" = "update" ]; then
		exit 0
	fi
fi



Package_Info() {
	INFO=$(sed -n "/Package: $1$/,/^$/p" $PACKAGES)
	if [ -z "$INFO" ]; then
	        echo APT: Unable to find package \"$1\"
	        exit 1
	fi
	echo -e $INFO
}

DEPENDENCIES=""

Package_Dependencies() {

	IFS=
        INFO=$( Package_Info $1 )
        IFS=,
	DEPS=$(echo "$INFO" | sed -n '/^Depends: /p' | sed 's/.*: //' | sed 's/ ([^,]*)//g' | sed 's/ //g'  )

	# if not allready in global list append
        for i in $DEPS; do
		contains=$(echo $DEPENDENCIES | grep $i)
		if [ -z "$contains" ]; then
			DEPENDENCIES="$DEPENDENCIES$i,"
			Package_Dependencies $i
		fi
        done

	# get sub depends

}

Package_Download() {
	IFS=
        INFO=$( Package_Info $1 ) 
	if [ "$?" = "1" ]; then
		echo $INFO
		exit 1
	fi

	FNAME=$( echo "$INFO" | sed -n '/Filename: /p' | sed 's/.* //' )
        echo APT: Downloading $1
	SNAME=$( echo $FNAME | sed 's/.*\///' )
        wget -o /dev/null -O $DEST/$SNAME $SOURCE$FNAME

}



#INFO - Print + Exit
if [ "$1" = "info" ]; then
	IFS=
        INFO=$( Package_Info $1 )
        echo "$INFO"
        exit 0
fi


if [ "$1" = "resolve" ]; then

#	echo APT: Resolving dependenceis for $2
	IFS=
	Package_Dependencies $2 
	
	echo "APT Dependencies for $2: $DEPENDENCIES"

	exit 0

fi


# CMD DOWNLOAD - Fetch and get dependecies
if [ "$1" = "download" ]; then
	shift
	if [ -z "$DEST" ]; then
		echo "APT: \$DEST not defined using ./"
		DEST=.
	else 
		# Lets just try to make it anyway
		mkdir $DEST
	fi

	for p in "$@"
	do
		Package_Download $p $DEST
		
		echo APT: Processing dependencies for $p	
		DEPENDENCIES=""		
		Package_Dependencies $p
		echo ATP: Dependencies for $p: $DEPENDENCIES 
		IFS=,
		for d in $DEPENDENCIES
		do
			Package_Download $d $DEST
		done	

	done	

       exit 0
fi

if [ "$1" = "install" ]; then
	shift


	for p in "$@"
	do
		DEST="$(mktemp)"
		mkdir $DEST

		Package_Download $p

		echo APT: Processing dependencies for $p
                DEPENDENCIES=""
                Package_Dependencies $p
                echo ATP: Dependencies for $p: $DEPENDENCIES
                IFS=,
                for d in $DEPENDENCIES
                do
                        Package_Download $d $DEST
                done

		/usr/bin/dpkg -i --force-all $DEST/*.deb	

		rm -rf $DEST

	done

	exit 0
fi

echo APT-GET-LIGHT - a Debian package manager for embedded devices by Tryll
echo APT: Unknown command $1
echo APT: Use update, info, resolve, download or install







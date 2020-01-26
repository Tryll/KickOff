#!/bin/sh

DEST=./

if [ ! -z $3 ]; then
        DEST=$3
fi

if [ "$1" = "extract" ]; then
        echo APT: Extracting $2

        ar x $2 data.tar.xz
        tar xf data.tar.xz -C $DEST
        rm -f data.tar.xz

        exit 0
fi


# DISTRO CHECK:
if [ -z $DISTRO ] && [ -z $ARCH ]; then
        echo APT: DISTRO and/or ARCH not defined
        exit 1
fi

SOURCE="http://deb.debian.org/debian/"
PACKAGES=/tmp/$DISTRO-$ARCH-packages

if [ ! -f "$PACKAGES" ]; then
        echo APT: Downloading packages overview for $DISTRO $ARCH.
        wget -qO- $SOURCE/dists/$DISTRO/main/binary-$ARCH/Packages.gz | gunzip > $PACKAGES
fi




# Look for package

INFO=$(sed -n "/Package: $2$/,/^$/p" $PACKAGES)
if [ -z "$INFO" ]; then
        echo APT: Unable to find package $2
	exit 1
fi


# CMD INFO - Print + Exit
if [ "$1" = "info" ]; then
        echo "$INFO"
	exit 0
fi



# CMD DOWNLOAD - Fetch and get dependecies
if [ "$1" = "download" ]; then

	FNAME=$( echo "$INFO" | sed -n '/Filename: /p' | sed 's/.* //' )
	echo APT: Downloading $2
	SNAME=$( echo $FNAME | sed 's/.*\///' )
	wget -o /dev/null -O $DEST/$SNAME $SOURCE$FNAME

	if [ "$PROCESSDEPENDENCIES" ]; then

		DEPENDS=$(echo "$INFO" | sed -n '/^Depends: /p' | sed 's/.*: //' )
		echo $DEPENDS

		if [ ! -z "$DEPENDS" ]; then
			# Download dependencies as well, if any	
			array=`echo $DEPENDS | sed 's/ ([^,]*)//g' | sed 's/,/\n/g'`
			for i in $array; do
				echo $2 downloading $i
				./$0 download $i $DEST	
			done	

		fi
	fi 


	exit 0
fi




echo APT: Unknown command $1
echo APT: Use info, download or install



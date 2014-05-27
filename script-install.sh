###################################################################
#                Created by: Gurjot Singh                         #
#                Email: bhattigurjot@gmail.com                    #
###################################################################

#!/bin/sh
echo ""
echo "######################################################"
echo "#        CHECKING---Internet Connection---           #"
echo "######################################################"
echo ""

	packet_loss=$(ping -c 5 -q 74.125.236.52 | \
	grep -oP '\d+(?=% packet loss)')

	if [ $packet_loss -le 50 ]
	then
		echo "::::::::::::Internet is working properly::::::::::::"
		echo ""
		echo "######################################################"
		echo "#        ---Installing Dependencies---               #"
		echo "######################################################"
		echo ""
if [ $(uname -m) = 'x86_64' ]; then
arch=amd64
else
arch=i386
fi

compile()
{
	libtoolize
	gettextize -f
	autoreconf -vfi
	intltoolize --force
	aclocal -I /usr/local/share/aclocal
	./configure --includedir=/usr/local/include/guile/2.0/
	set -e
	make
	set +e
	sudo make install
}

check_apt()
{
result=$(dpkg-query -W -f='${package}\n' "$1")
if  [ "$result" = "$1" ]; then
		echo "$1 already installed"
	else
		echo "$1 is not installed in your system"
		echo "You want to install it now: (y for yes, " \
			 "otherwise to abort):"
		read Y
		if [ $Y = y ] || [ $Y = Y ]; then
			sudo apt-get install $1
			sudo apt-get -f install
		else 
			echo "Aborted" 
			exit
		fi
	fi
}

check_wget()
{
result=$(guile -v 2>&1 | head -n 1)
exp='guile (GNU Guile) 2.0.11'
if  [ "$result" = "$exp" ]; then
		echo "$1 already installed"
	else
		echo "$1 is not installed in your system"
		echo "You want to install it now: (y for yes, " \
			 "otherwise to abort):"
		read Y
		if [ $Y = y ] || [ $Y = Y ]; then
			if [ ! -d "tmp" ]; then
				mkdir tmp
				cd tmp
			else
				cd tmp
			fi
				wget -c http://ftp.us.debian.org/debian/pool/main/libg/libgc/libgc1c2_7.2d-6_$arch.deb http://ftp.us.debian.org/debian/pool/main/g/guile-2.0/guile-2.0-libs_2.0.11+1-1_$arch.deb http://ftp.us.debian.org/debian/pool/main/g/guile-2.0/guile-2.0_2.0.11+1-1_$arch.deb
				sudo dpkg -i libgc1c2_7.2d-6_$arch.deb guile-2.0-libs_2.0.11+1-1_$arch.deb guile-2.0_2.0.11+1-1_$arch.deb

				cd ..
				
		else 
			echo "Aborted" 
			exit
		fi
	fi
}

Dependencies()
{
dep=(automake autoconf libc-dev libtinfo-dev libncurses5-dev libreadline6-dev libgtk2.0-0 libgtk2.0-0-dbg libgtk2.0-dev libglade2-0 libglade2-dev libxml2-dev intltool libtool gnutls-bin binutils binutils-dev)
dep2=(guile-2.0.11)
for i in "${dep[@]}"
	do
		check_apt $i
	done
for i in "${dep2[@]}"
	do
		check_wget $i
	done

}

Dependencies
echo "::::::::::::Dependencies Installed::::::::::::"
echo ""
echo "######################################################"
echo "#            ---Begin Compilation---                 #"
echo "######################################################"
echo ""
compile

rm -rf tmp

echo ""
echo "######################################################"
echo "#    Dr.Geo has been Installed successfully!         #"
echo "#    Run drgeo directly from command line.           #"	
echo "######################################################"
echo ""

else 
echo ":::::::::::No Internet Connection Found!:::::::::::"
echo ":::::::::::Check Your Internet Connection::::::::::"
echo ":::::::::::Or Try Again Later:::::::::::"
exit
fi

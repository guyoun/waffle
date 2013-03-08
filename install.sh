#!/bin/bash 
#Usage : ./install.sh -a test -p test -c core -v 1.3 -i
DEFAULT_INDEX_URL="https://raw.github.com/guyoun/waffle/master/default/index.php-1.3"
CAKEPHP_REPOSITORY="https://github.com/cakephp/cakephp.git"
project="default_project"
cakephp_core="cakephp_core"
cakephp_ver="1.3"
app="default_app"
command="install"

set -- $(getopt -u -o iu:c:v:p:a: -l install,uninstall:cake:ver:project:app:-- "$@")
while [ $# -gt 0 ]
do
    case "$1" in
    (-a) appe="$2"; shift;;
    (-c) cakephp_core_dir=$2; shift;;
    (-p) project_name=$2; shift;;
    (-v) cakephp_ver=$2; shift;;
    (-i) command="install";;
    (-u) command="uninstall";;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*)  break;;
    esac
    shift
done

case $command in
	install)
		install_path=$PWD
		project_root_path=$install_path/$project
		cakephpcore_path=$install_path/$cakephp_core/$ccakephp_ver
		app_path=$install_path/$project/$app

		echo "install"
		#download cakephp core
		mkdir $cakephp_core_dir
		
		cd $cakephp_core_dir
		git clone $CAKEPHP_REPOSITORY $cakephp_ver
		
		cd $cakephp_ver
		git checkout -b $cakephp_ver origin/$cakephp_ver
		
		#generate index.php
		cd $install_path
		wget $DEFAULT_INDEX_URL
		sed -e "s;%ROOT%;$project_rooti_path;" -e "s;%APP%;$app;" -e "s;%CORE%;$cakephp_core_path;"  index.php-1.3 > index.php
	;;
	uninstall)
		echo "uninstall"
	;;	
esac


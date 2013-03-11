#!/bin/bash 
#Usage : ./install.sh -a test -p test -c core -v 1.3 -i
DEFAULT_INDEX_URL="https://raw.github.com/guyoun/waffle/master/default/index.php-1.3"
CAKEPHP_REPOSITORY="https://github.com/cakephp/cakephp.git"
project="default_project"
cakephp_core="cakephp_core"
cakephp_ver="1.3"
app="default_app"
command="install"

set -- $(getopt -u -o iuc:v:p:a: -l install,uninstallcake:ver:project:app: -- "$@")
while [ $# -gt 0 ]
do
    case "$1" in
    (-a) app=$2; shift;;
    (-c) cakephp_core=$2; shift;;
    (-p) project=$2; shift;;
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
		cakephp_core_path=$install_path/$cakephp_core/$cakephp_ver

		echo "Install cakephp core, make project skeleton"

		#download cakephp core
		mkdir $cakephp_core		
		cd $cakephp_core
		git clone $CAKEPHP_REPOSITORY $cakephp_ver
		
		cd $cakephp_ver
		git checkout -b $cakephp_ver origin/$cakephp_ver
		
		#make project directory and copy app, webroot, change persmission tmp directory
		cd $install_path
		mkdir $project
		cd $project
		mkdir plugins
		rsync -a --exclude='webroot' $cakephp_core_path/app/* $app/
		chmod 707 -R $app/tmp
		cp -r $cakephp_core_path/app/webroot public_html

		#generate index.php for this environment
		cd $install_path
		curl $DEFAULT_INDEX_URL > index.php-1.3
		sed -e "s;%ROOT%;$project_root_path;" -e "s;%APP%;$app;" -e "s;%CORE%;$cakephp_core_path;"  index.php-1.3 > index.php		
		mv index.php $project_root_path/public_html/
		rm index.php-1.3
	;;
	uninstall)
		echo "Uninstall is not supported"
	;;	
esac
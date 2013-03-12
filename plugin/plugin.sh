#!/bin/bash 
#Usage : ./install.sh -a test -p test -c core -v 1.3 -i
PLUGIN_REPOSITORY="https://github.com/guyoun/waffle.git"
plugin_name="plugin_name"
plugin_ver="old"
app="default_app"
schema_name="schema_name"
command="install"

set -- $(getopt -u -o iua:n:v: -l install,uninstallapp:name:version: -- "$@")
while [ $# -gt 0 ]
do
    case "$1" in
    (-a) app=$2; shift;;
    (-n) plugin_name=$2; shift;;
    (-v) plugin_ver=$2; shift;;
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
		echo "Install plugin"
		plugins_root=$PWD
		project_root="$(dirname "$plugins_root")"
		app_root=$project_root/$app

		#download plugi
		git clone $PLUGIN_REPOSITORY $plugin_name
		cd $plugin_name
		git checkout -b $plugin_ver origin/$plugin_ver

		cd $app_root/plugins
		ln -s $plugins_root/$plugin_name $plugin_name		

		#create schema
		cake -app $app_root schema create --name $plugin_name.schema_name
	;;
	uninstall)
		echo "Uninstall is not supported"
	;;	
esac
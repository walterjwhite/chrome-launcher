#!/bin/sh

_add_option() {
	if [ "$#" -eq "2" ] && [ -n "$1" ]; then
		_OPTIONS="$_OPTIONS --${2}=$1"
	fi
}

_SESSION_NAME=default

for _ARG in $@; do
	case $_ARG in
	-s=*)
		_SESSION_NAME="${_ARG#*=}"
		;;
	-b=*)
		_BROWSER="${_ARG#*=}"
		;;
	-e)
		_EXPORT_HISTORY=1
		;;
	-d)
		_EXPORT_DATETIME=1
		;;
	-p=*)
		_PROXY_SERVER="${_ARG#*=}"
		;;
	# enable browser remote control
	-r)
		_BROWSER_REMOTE_PORT=0
		;;
	# create new instance
	-n)
		_NEW=1
		;;
	-i)
		_OPTIONS="$_OPTIONS --disable-web-security"
		;;
	esac
done

_add_option "$_BROWSER_REMOTE_PORT" "remote-debugging-port"
_add_option "$_PROXY_SERVER" "proxy-server"

_SESSION_PATH=_APPLICATION_DATA_PATH_/$_SESSION_NAME
mkdir -p $(dirname $_SESSION_PATH)

_new_instance

_COMMAND="$_RUN_AS_COMMAND $_BROWSER $_OPTIONS"

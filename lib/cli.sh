#!/bin/sh

_add_option() {
	if [ $# -eq 2 ] && [ -n "$2" ]; then
		_OPTIONS="$_OPTIONS --${1}=$2"
	fi
}

_SESSION_NAME=default

for _ARG in $@; do
	case $_ARG in
	-s=*)
		_SESSION_NAME="${_ARG#*=}"
		;;
	-b=*)
		_CONF_BROWSER="${_ARG#*=}"
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
		_CONF_BROWSER_REMOTE_PORT=0
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

_add_option "remote-debugging-port" "$_CONF_BROWSER_REMOTE_PORT"
_add_option "proxy-server" "$_PROXY_SERVER"

_SESSION_FILE=_APPLICATION_DATA_PATH_/$_SESSION_NAME
mkdir -p $(dirname $_SESSION_FILE)

_new_instance

_COMMAND="$_CONF_RUN_AS_CMD $_CONF_BROWSER $_OPTIONS"

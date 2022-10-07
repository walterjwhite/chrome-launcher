#!/bin/sh

_CONFIGURATION_DIRECTORY=~/.config/chromium

_new_instance() {
	if [ -e $_SESSION_FILE ]; then
		return
	fi

	_info 'preparing instance'
	_INSTANCE_DIRECTORY=$(mktemp -d -t chrome.$_SESSION_NAME)

	_add_option "user-data-dir" $_INSTANCE_DIRECTORY

	# prepare instance
	mkdir -p ${_INSTANCE_DIRECTORY}/Default

	if [ ! -e $_CONFIGURATION_DIRECTORY/Default/Preferences ]; then
		_exit_with_error "$_CONFIGURATION_DIRECTORY/Default/Preferences does not exist" 1
	fi

	cp -R $_CONFIGURATION_DIRECTORY/Default/Preferences "$_INSTANCE_DIRECTORY/Default/"
	cp -R $_CONFIGURATION_DIRECTORY/Default/Extensions "$_INSTANCE_DIRECTORY/Default/" 2>/dev/null

	# automatically update configuration
	_ESCAPED_INSTANCE_DIRECTORY=$(printf '%s' $_INSTANCE_DIRECTORY | sed -e "s/\//\\\\\//g")
	mkdir -p $_INSTANCE_DIRECTORY/Downloads

	$_CONF_GNU_SED -i "s/\"default_directory\":\".*\/Downloads\"}/\"default_directory\":\"${_ESCAPED_INSTANCE_DIRECTORY}\/Downloads\"}/" "$_NEW_INSTANCE_DIRECTORY/Default/Preferences"
}

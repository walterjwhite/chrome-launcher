#!/bin/sh

_CONFIGURATION_DIRECTORY=~/.config/chromium

_new_instance() {
	if [ -e $_SESSION_FILE ]; then
		return
	fi

	_info 'preparing instance'
	_INSTANCE_DIRECTORY=$($_CONF_RUN_AS_CMD mktemp -d -t chrome.$_SESSION_NAME)

	_add_option "user-data-dir" $_INSTANCE_DIRECTORY

	# prepare instance
	$_CONF_RUN_AS_CMD mkdir -p ${_INSTANCE_DIRECTORY}/Default

	if [ ! -e $_CONFIGURATION_DIRECTORY/Default/Preferences ]; then
		_exit_with_error "$_CONFIGURATION_DIRECTORY/Default/Preferences does not exist" 1
	fi

	$_SUDO_COMMAND cp -R $_CONFIGURATION_DIRECTORY/Default/Preferences "$_INSTANCE_DIRECTORY/Default/"
	$_SUDO_COMMAND cp -R $_CONFIGURATION_DIRECTORY/Default/Extensions "$_INSTANCE_DIRECTORY/Default/" 2>/dev/null

	if [ -n "$_RUN_AS_USER" ]; then
		$_SUDO_COMMAND chown -R $_RUN_AS_USER "$_INSTANCE_DIRECTORY/Default/Preferences"
		$_SUDO_COMMAND chown -R $_RUN_AS_USER "$_INSTANCE_DIRECTORY/Default/Extensions" 2>/dev/null
	fi

	# automatically update configuration
	_ESCAPED_INSTANCE_DIRECTORY=$(echo $_INSTANCE_DIRECTORY | sed -e "s/\//\\\\\//g")
	$_CONF_RUN_AS_CMD mkdir -p $_INSTANCE_DIRECTORY/Downloads

	$_CONF_RUN_AS_CMD $_CONF_GNU_SED -i "s/\"default_directory\":\".*\/Downloads\"}/\"default_directory\":\"${_ESCAPED_INSTANCE_DIRECTORY}\/Downloads\"}/" "$_NEW_INSTANCE_DIRECTORY/Default/Preferences"
}

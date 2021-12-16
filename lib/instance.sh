#!/bin/sh

_INSTANCE_DIRECTORY=~/.config/chromium

_new_instance() {
	if [ -e $_SESSION_FILE ]; then
		return
	fi

	doLog 'preparing instance'
	_NEW_INSTANCE_DIRECTORY=$($_RUN_AS_COMMAND mktemp -d -t chrome/$_SESSION_NAME)

	_add_option "user-data-dir" $_NEW_INSTANCE_DIRECTORY

	# prepare instance
	$_RUN_AS_COMMAND mkdir -p ${_NEW_INSTANCE_DIRECTORY}/Default

	if [ ! -e $_INSTANCE_DIRECTORY/Default/Preferences ]; then
		exitWithError "$_INSTANCE_DIRECTORY/Default/Preferences does not exist" 1
	fi

	$_SUDO_COMMAND cp -R $_INSTANCE_DIRECTORY/Default/Preferences "$_NEW_INSTANCE_DIRECTORY/Default/"
	$_SUDO_COMMAND cp -R $_INSTANCE_DIRECTORY/Default/Extensions "$_NEW_INSTANCE_DIRECTORY/Default/" 2>/dev/null

	if [ -n "$_RUN_AS_USER" ]; then
		$_SUDO_COMMAND chown -R $_RUN_AS_USER "$_NEW_INSTANCE_DIRECTORY/Default/Preferences"
		$_SUDO_COMMAND chown -R $_RUN_AS_USER "$_NEW_INSTANCE_DIRECTORY/Default/Extensions" 2>/dev/null
	fi

	# automatically update configuration
	_ESCAPED_INSTANCE_DIRECTORY=$(echo $_NEW_INSTANCE_DIRECTORY | sed -e "s/\//\\\\\//g")
	$_RUN_AS_COMMAND mkdir -p $_NEW_INSTANCE_DIRECTORY/Downloads

	$_RUN_AS_COMMAND $_GNU_SED -i "s/\"default_directory\":\".*\/Downloads\"}/\"default_directory\":\"${_ESCAPED_INSTANCE_DIRECTORY}\/Downloads\"}/" "$_NEW_INSTANCE_DIRECTORY/Default/Preferences"
	_INSTANCE_DIRECTORY=$_NEW_INSTANCE_DIRECTORY

	unset _NEW_INSTANCE_DIRECTORY
}

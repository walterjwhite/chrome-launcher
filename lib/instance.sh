#!/bin/sh

_INSTANCE_DIRECTORY=~/.config/chromium

_new_instance() {
	if [ -z "$_NEW" ]; then
		return
	fi

	_is_new_instance_valid

	doLog 'preparing instance'
	_NEW_INSTANCE_DIRECTORY=$($_RUN_AS_COMMAND mktemp -d)

	_add_option $_NEW_INSTANCE_DIRECTORY "user-data-dir"

	# prepare instance
	$_RUN_AS_COMMAND mkdir -p ${_NEW_INSTANCE_DIRECTORY}/Default

	$_SUDO_COMMAND cp -R $_INSTANCE_DIRECTORY/Default/Preferences "$_NEW_INSTANCE_DIRECTORY/Default/"
	$_SUDO_COMMAND cp -R $_INSTANCE_DIRECTORY/Default/Extensions "$_NEW_INSTANCE_DIRECTORY/Default/"

	if [ -n "$_RUN_AS_USER" ]; then
		$_SUDO_COMMAND chown -R $_RUN_AS_USER "$_NEW_INSTANCE_DIRECTORY/Default/Preferences"
		$_SUDO_COMMAND chown -R $_RUN_AS_USER "$_NEW_INSTANCE_DIRECTORY/Default/Extensions"
	fi

	# automatically update configuration
	_ESCAPED_INSTANCE_DIRECTORY=$(echo $_NEW_INSTANCE_DIRECTORY | sed -e "s/\//\\\\\//g")
	$_RUN_AS_COMMAND mkdir -p $_NEW_INSTANCE_DIRECTORY/Downloads

	$_RUN_AS_COMMAND $_GNU_SED -i "s/\"default_directory\":\".*\/Downloads\"}/\"default_directory\":\"${_ESCAPED_INSTANCE_DIRECTORY}\/Downloads\"}/" "$_NEW_INSTANCE_DIRECTORY/Default/Preferences"
	_INSTANCE_DIRECTORY=$_NEW_INSTANCE_DIRECTORY

	unset _NEW_INSTANCE_DIRECTORY
}

_is_new_instance_valid() {
	if [ -e $_SESSION_PATH ]; then
		exitWithError "Session ($_SESSION_NAME) @ $_SESSION_PATH already exists." 1
	fi
}

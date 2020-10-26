#!/bin/sh

_new_instance(){
    if [ -z "$_NEW" ]
    then
        return
    fi

    _is_new_instance_valid

    doLog 'preparing instance'
    _INSTANCE_DIRECTORY=$($_RUN_AS_COMMAND mktemp -d)

    _add_option $_INSTANCE_DIRECTORY "user-data-dir"

	# prepare instance
	$_RUN_AS_COMMAND mkdir -p ${_INSTANCE_DIRECTORY}/Default

	$_SUDO_COMMAND cp ~/.config/chromium/Default/Preferences "$_INSTANCE_DIRECTORY/Default/Preferences"

    if [ -n "$_RUN_AS_USER" ]
    then
	    $_SUDO_COMMAND chown -R $_RUN_AS_USER "$_INSTANCE_DIRECTORY/Default/Preferences"
    fi

	# automatically update configuration
	_ESCAPED_INSTANCE_DIRECTORY=$(echo $_INSTANCE_DIRECTORY | sed -e "s/\//\\\\\//g")
	$_RUN_AS_COMMAND mkdir -p $_INSTANCE_DIRECTORY/Downloads

	$_RUN_AS_COMMAND $_GNU_SED -i "s/\"default_directory\":\".*\/Downloads\"}/\"default_directory\":\"${_ESCAPED_INSTANCE_DIRECTORY}\/Downloads\"}/" "$_INSTANCE_DIRECTORY/Default/Preferences"
}

_is_new_instance_valid() {
	if [ -e $_SESSION_PATH ]
	then
		exitWithError "Session ($_SESSION_NAME) @ $_SESSION_PATH already exists." 1
	fi
}
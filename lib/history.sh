#!/bin/sh

_COLUMNS=url

_export_history() {
	if [ -n "$_EXPORT_DATETIME" ]; then
		_COLUMNS="datetime(last_visit_time/1000000-11644473600,'unixepoch','localtime'),$_COLUMNS"
	fi

	_QUERY="SELECT $_COLUMNS FROM urls ORDER BY last_visit_time DESC"

	_SQLITE_DATABASE=$_INSTANCE_DIRECTORY/Default/History

	if [ -n "$_FILENAME" ]; then
		_export_history_to_file "$_FILENAME"
	else
		_info "$_SESSION_NAME browser history"

		# if [ $(tty | grep "/dev/pts" -c) -gt 0 ]; then
		# 	sqlite3 -csv $_SQLITE_DATABASE "$_QUERY"
		# else
		_HISTORY_FILE=_APPLICATION_DATA_PATH_/history/$_SESSION_NAME/$(date "+%Y%m%d%H%M%S")

		_export_history_to_file "$_HISTORY_FILE"
		# fi
	fi
}

_export_history_to_file() {
	_info "$_SESSION_NAME browser history >$1"

	mkdir -p $(dirname $1)
	sqlite3 -csv $_SQLITE_DATABASE "$_QUERY" >$1 2>&1
}

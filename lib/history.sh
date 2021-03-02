#!/bin/sh

_COLUMNS=url

_export_history() {
	if [ -n "$_EXPORT_DATETIME" ]; then
		_COLUMNS="datetime(last_visit_time/1000000-11644473600,'unixepoch','localtime'),$_COLUMNS"
	fi

	_QUERY="SELECT $_COLUMNS FROM urls ORDER BY last_visit_time DESC"

	_HISTORY_FILE=$_INSTANCE_DIRECTORY/Default/History

	if [ -n "$_FILENAME" ]; then
		info "$_SESSION_NAME browser history >$_FILENAME"

		mkdir -p $(dirname $_FILENAME)
		sqlite3 -csv $_HISTORY_FILE "$_QUERY" >$_FILENAME
	else
		info "$_SESSION_NAME browser history"
		sqlite3 -csv $_HISTORY_FILE "$_QUERY"
	fi
}

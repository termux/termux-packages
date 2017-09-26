mpd_test=$(pgrep -f /data/data/com.termux/files/usr/libexec/mpd)
CmdArgs=$(echo "$@")
#echo $mpd_test
mkdir -p ~/.mpd
mkdir -p ~/.mpd/playlists
touch ~/.mpd/state
touch ~/.mpd/log
touch ~/.mpd/pid
if [ "x$CmdArgs" = x ] ; then
	if [ -z "$MULTIPLE_MPDS"  ] ; then
		if [ -n "$mpd_test" ] ;  then
		echo -n "restart music player daemon (y/n)? "
		read answer
			if echo "$answer" | grep -iq "^y" ;then
			echo "restarting music player daemon"
			pgrep -f  /data/data/com.termux/files/usr/libexec/mpd  | while read line; do kill  "$line"; done
			else 
			echo "doing nothing"
			exit
			fi
		else
		echo "starting mpd the music player daemon"
		fi
		sleep 0.5;
		chmod +rw ~/.mpd/*  2>&1 > /dev/null
		rm -rf ~/.mpd/pid   2>&1 > /dev/null
	fi
fi

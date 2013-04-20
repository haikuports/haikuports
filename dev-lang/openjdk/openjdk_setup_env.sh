#!/bin/sh
_progress () {
	notify --type progress --group openJDK \
		--icon /boot/system/kernel_x86 \
		--messageID $0_$$ \
		--title "Set OpenJDK env..." \
		--progress "$1" "$2" >/dev/null
}

_progress 0.2 ".profile"
cd
if [ -e .profile ];
then
	echo
else
	touch .profile
fi

_progress 0.4 "JAVA_HOME"
grep "export JAVA_HOME=" .profile >/dev/null
if [ $? == 1 ];
then
	echo "export JAVA_HOME=\`finddir B_COMMON_DIRECTORY\`/jdk" >>.profile
fi

_progress 0.6 "PATH"
grep "export PATH=\$JAVA_HOME/bin:\$PATH" .profile >/dev/null
if [ $? == 1 ];
then
	echo "export PATH=\$JAVA_HOME/bin:\$PATH" >>.profile
fi

_progress 0.8 "LIBRARY_PATH"
export _SEARCH=$JAVA_HOME/jre/lib/i386
echo $_SEARCH | grep $LIBRARY_PATH >/dev/null
grep "export LIBRARY_PATH=\$JAVA_HOME/jre/lib/i386:\$LIBRARY_PATH" .profile >/dev/null
if [ $? == 1 ];
then
	echo "export LIBRARY_PATH=\$JAVA_HOME/jre/lib/i386:\$LIBRARY_PATH" >>.profile
fi
_progress 1.0 "done"

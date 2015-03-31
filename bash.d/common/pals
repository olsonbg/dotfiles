# Setup paths for installs PALS packages
# They are all in /usr/local/positron/...
TPATH=""
CPATH=/usr/local/positron/bin

if [ `echo $PATH |grep -c $CPATH` = "0" ]; then
	TPATH=$PATH:$CPATH
fi

if [ "$TPATH" != "" ]; then
	PATH=$TPATH
	export PATH
fi

TPATH=""
CPATH=/usr/local/positron/man

if [ `echo $MANPATH |grep -c $CPATH` = "0" ]; then
	TPATH=$MANPATH:$CPATH
fi

if [ "$TPATH" != "" ]; then
	MANPATH=$TPATH
	export MANPATH
fi

TPATH=""
CPATH=/usr/local/positron/lib

if [ "$LD_LIBRARY_PATH" = "" ]; then
   TPATH=$CPATH
   LD_LIBRARY_PATH=$CPATH
fi

if [ `echo $LD_LIBRARY_PATH |grep -c $CPATH` = "0" ]; then
	TPATH=$LD_LIBRARY_PATH:$CPATH
fi

if [ "$TPATH" != "" ]; then
	LD_LIBRARY_PATH=$TPATH
	export LD_LIBRARY_PATH
fi

if [ -f ~/bin/pos_fit.sh ]; then
  source ~/bin/pos_fit.sh 1
#  alias setup1='source ~/bin/pos_fit.sh 1'
#  alias setup2='source ~/bin/pos_fit.sh 2'
fi


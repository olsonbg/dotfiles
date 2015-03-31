#
# Make a cache directory in ram
#
if [ ! -e /dev/shm/cache-bgo ] ; then
	mkdir --mode=700 /dev/shm/cache-bgo
fi
if [ ! -e ~/.cache ] ; then
	ln -s /dev/shm/cache-bgo ~/.cache
fi

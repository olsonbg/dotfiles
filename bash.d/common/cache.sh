#
# Make a cache directory in ram and link ~/.cache to it.
#

# Create a directory in ram.
if [ ! -e /dev/shm/cache-$USER ] ; then
	mkdir --mode=700 "/dev/shm/cache-$USER"
fi

# If ~/.cache already exists, and it's not a symbolic link, than back it up.
[[ -d ~/.cache ]] && [[ ! -h ~/.cache ]] && mv ~/.cache ~/.cache-old

# Link ~/.cache to the cache directory in ram.
if [ ! -e ~/.cache ] ; then
	ln -s "/dev/shm/cache-$USER" ~/.cache
fi

#!/bin/sh

ICONDIR="$(dirname $0)/icons"
MENUDIR="$(dirname $0)/menus"

METHOD=install
#METHOD=uninstall

echo "${METHOD}ing icons..."

for i in "$ICONDIR"/*; do
	r=$(basename $i)
	for f in "$i"/*; do
		xdg-icon-resource $METHOD --size $r "$f"
	done
done

echo "${METHOD}ing *.desktop files"

for i in "$MENUDIR"/*.desktop; do
	xdg-desktop-menu $METHOD  --noupdate \
	                 "$MENUDIR/userapp-MyApps.directory" "$i"
done

for i in "$MENUDIR/VMs"/*.desktop; do
	xdg-desktop-menu $METHOD  --noupdate \
	                 "$MENUDIR/userapp-MyApps.directory" \
	                 "$MENUDIR/VMs/userapp-vmprogs.directory" "$i"
done

xdg-desktop-menu forceupdate

FEHMIME="userapp-feh_browser_windowed.desktop"
TYPES=$(cat "$MENUDIR/$FEHMIME" |sed -e 's/;/ /g' -ne 's/^MimeType=//p')

echo "Updating mimetypes to use $FEHMIME"
xdg-mime default $FEHMIME $TYPES
#xdg-mime query default image/png

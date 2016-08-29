# How to install

## Install submenu and menu items

All in one line (the most efficient way):

```bash
xdg-desktop-menu install ./userapp-MyApps.directory ./chrome-calendar.desktop ./chrome-drive.desktop ./chrome-gmail.desktop ./chrome-pandora.desktop
```

Or, in a slightly less efficient manner:

```bash
xdg-desktop-menu install --noupdate ./userapp-MyApps.directory ./chrome-calendar.desktop
xdg-desktop-menu install --noupdate ./userapp-MyApps.directory ./chrome-drive.desktop
xdg-desktop-menu install --noupdate ./userapp-MyApps.directory ./chrome-gmail.desktop
xdg-desktop-menu install --noupdate ./userapp-MyApps.directory ./chrome-pandora.desktop
xdg-desktop-menu forceupdate
```

## Now install the icons

```bash
xdg-icon-resource install --size 16 ./chrome-calendar.png
xdg-icon-resource install --size 16 ./chrome-drive.png
xdg-icon-resource install --size 16 ./chrome-gmail.png
xdg-icon-resource install --size 16 ./chrome-pandora.png
```

## For using my custom feh scripts with images

First need to install a .desktop file describing the program to use and
lists mime types

```bash
xdg-desktop-menu install ./userapp-feh_browser_fullscreen.desktop
xdg-desktop-menu install ./userapp-feh_browser_windowed.desktop
```

Now associate the desktop file to each image type that it supports. Here we
use userapp-feh_browser_windowed.desktop:

```bash
xdg-mime default userapp-feh_browser_windowed.desktop image/bmp image/gif image/jpeg image/jpg image/pjpeg image/png image/tiff image/x-bmp image/x-pcx image/x-png image/x-portable-anymap image/x-portable-bitmap image/x-portable-graymap image/x-portable-pixmap image/x-tga image/x-xbitmap image/svg+xml image/svg+xml-compressed
```

### Verify the mime association

This will list the desktop file associated with jpg images

```bash
xdg-mime query default image/jpg
```


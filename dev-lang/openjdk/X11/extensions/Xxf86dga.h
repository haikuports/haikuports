/*
   Copyright (c) 1999  XFree86 Inc
*/

#ifndef _XF86DGA_H_
#define _XF86DGA_H_

#include <X11/Xfuncproto.h>
#include <X11/extensions/xf86dgaconst.h>
#include <X11/extensions/xf86dga1.h>

_XFUNCPROTOBEGIN

typedef struct {
   int type;
   unsigned long serial;
   Display *display;
   int screen;
   Time time;
   unsigned int state;
   unsigned int button;
} XDGAButtonEvent;

typedef struct {
   int type;
   unsigned long serial;
   Display *display;
   int screen;
   Time time;
   unsigned int state;
   unsigned int keycode;
} XDGAKeyEvent;

typedef struct {
   int type;
   unsigned long serial;
   Display *display;
   int screen;
   Time time;
   unsigned int state;
   int dx;
   int dy;
} XDGAMotionEvent;

typedef union {
  int type;
  XDGAButtonEvent xbutton;
  XDGAKeyEvent	  xkey;
  XDGAMotionEvent xmotion;
  long		  pad[24];
} XDGAEvent;

Bool XDGAQueryExtension(
    Display 	*dpy,
    int 	*eventBase,
    int 	*erroBase
);

Bool XDGAQueryVersion(
    Display 	*dpy,
    int 	*majorVersion,
    int 	*minorVersion
);

XDGAMode* XDGAQueryModes(
    Display	*dpy,
    int 	screen,
    int		*num
);

XDGADevice* XDGASetMode(
    Display	*dpy,
    int		screen,
    int		mode
);

Bool XDGAOpenFramebuffer(
    Display	*dpy,
    int 	screen
);

void XDGACloseFramebuffer(
    Display	*dpy,
    int		screen
);

void XDGASetViewport(
    Display	*dpy,
    int		screen,
    int		x,
    int		y,
    int		flags
);

void XDGAInstallColormap(
    Display	*dpy,
    int		screen,
    Colormap	cmap
);

Colormap XDGACreateColormap(
    Display	*dpy,
    int 	screen,
    XDGADevice  *device,
    int 	alloc
);

void XDGASelectInput(
    Display	*dpy,
    int		screen,
    long	event_mask
);

void XDGAFillRectangle(
    Display	*dpy,
    int		screen,
    int		x,
    int		y,
    unsigned int	width,
    unsigned int	height,
    unsigned long	color
);


void XDGACopyArea(
    Display	*dpy,
    int		screen,
    int		srcx,
    int		srcy,
    unsigned int	width,
    unsigned int	height,
    int		dstx,
    int		dsty
);


void XDGACopyTransparentArea(
    Display	*dpy,
    int		screen,
    int		srcx,
    int		srcy,
    unsigned int	width,
    unsigned int	height,
    int		dstx,
    int		dsty,
    unsigned long key
);

int XDGAGetViewportStatus(
    Display	*dpy,
    int		screen
);
   
void XDGASync(
    Display	*dpy,
    int		screen
);

Bool XDGASetClientVersion(
    Display	*dpy
);

void XDGAChangePixmapMode(
    Display 	*dpy,
    int		screen,
    int		*x,
    int		*y,
    int		mode
);


void XDGAKeyEventToXKeyEvent(XDGAKeyEvent* dk, XKeyEvent* xk);


_XFUNCPROTOEND
#endif /* _XF86DGA_H_ */

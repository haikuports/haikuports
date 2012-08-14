/*

Copyright (c) 1995  Jon Tombs
Copyright (c) 1995  XFree86 Inc

*/

/************************************************************************

   THIS IS THE OLD DGA API AND IS OBSOLETE.  PLEASE DO NOT USE IT ANYMORE

************************************************************************/

#ifndef _XF86DGA1_H_
#define _XF86DGA1_H_

#include <X11/Xfuncproto.h>
#include <X11/extensions/xf86dga1const.h>

_XFUNCPROTOBEGIN

Bool XF86DGAQueryVersion(
    Display*		/* dpy */,
    int*		/* majorVersion */,
    int*		/* minorVersion */
);

Bool XF86DGAQueryExtension(
    Display*		/* dpy */,
    int*		/* event_base */,
    int*		/* error_base */
);

Status XF86DGAGetVideoLL(
    Display*			/* dpy */,
    int				/* screen */,
    unsigned int *		/* base addr */,
    int *			/* width */,
    int *			/* bank_size */,
    int *			/* ram_size */ 
);

Status XF86DGAGetVideo(
    Display*			/* dpy */,
    int				/* screen */,
    char **			/* base addr */,
    int *			/* width */,
    int *			/* bank_size */,
    int *			/* ram_size */
);

Status XF86DGADirectVideo(
    Display*			/* dpy */,
    int				/* screen */,
    int 			/* enable */
);

Status XF86DGADirectVideoLL(
    Display*			/* dpy */,
    int				/* screen */,
    int 			/* enable */
);

Status XF86DGAGetViewPortSize(
    Display*			/* dpy */,
    int				/* screen */,
    int *			/* width */,
    int *			/* height */
);

Status XF86DGASetViewPort(
    Display*			/* dpy */,
    int				/* screen */,
    int x			/* X */,
    int y			/* Y */
);

Status XF86DGAGetVidPage(
    Display*			/* dpy */,
    int				/* screen */,
    int *			/* vid page */
);

Status XF86DGASetVidPage(
    Display*			/* dpy */,
    int				/* screen */,
    int				/* vid page */
);

Status XF86DGAInstallColormap(
    Display*			/* dpy */,
    int				/* screen */,
    Colormap			/*Colormap */
);

int XF86DGAForkApp(
    int screen
);

Status XF86DGAQueryDirectVideo(
    Display *		/* dpy */,
    int			/* screen */,
    int *		/* flags */
);

Bool XF86DGAViewPortChanged(
    Display *		/* dpy */,
    int			/* screen */,
    int			/* n */
);


_XFUNCPROTOEND

#endif /* _XF86DGA1_H_ */

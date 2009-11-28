/*
 *                              UNIX2DOS.C
 *
 * Convert lf's to crlf combinations in a file but keep it's original
 * date/time stamp.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <utime.h>
#include <sys/types.h>
#include <sys/stat.h>
#ifndef TRUE
#	define TRUE  (1)
#	define FALSE (0)
#endif

#define R_CNTRL   "r"
#define W_CNTRL   "w"



struct stat s_buf;

int u2dos (char *path);


main (int argc, char **argv)
{
	char *path;
	while (--argc>0)
	{
		if (stat (path=*++argv, &s_buf) != -1)
		{
			printf ("Unix2Dos: Cleaning file %s ...\n", path);
			if (u2dos (path))
			{
				fprintf (stderr, "Unix2Dos: Problems cleaning file %s\n", path);
			}
		}
		else
		{
			fprintf (stderr, "Unix2Dos: Can't stat '%s'\n", path);
		}
	}
}




int u2dos (char *path)
{
	FILE *in, *out;
	int ch,
	    rval = FALSE;
	char temppath [16];
/*	struct utimbuf { time_t actime, modtime; } ut_buf; */
	struct utimbuf ut_buf;

	strcpy (temppath, "./clntmp");
	if ((in=fopen (path, R_CNTRL)) == (FILE *) 0)
		return TRUE;
	if ((out=fopen (temppath, W_CNTRL)) == (FILE *) 0)
	{
		fclose (in);
		return TRUE;
	}
	while ((ch = getc (in)) != EOF)
		if (((ch == '\012') && (putc ('\015', out) == EOF)) ||
		    (putc (ch, out) == EOF)                   )
		{
			rval = TRUE;
			break;
		}
	if (fclose (in) == EOF)
	{
		rval = TRUE;
	}
	if (fclose (out) == EOF)
	{
		rval = TRUE;
	}
	ut_buf.actime = s_buf.st_atime;
	ut_buf.modtime = s_buf.st_mtime;
	if (utime (temppath, &ut_buf) == -1)
		rval = TRUE;
	if (unlink (path) == -1)
		rval = TRUE;
	if (rval)
	{
		unlink (temppath);
		return TRUE;
	}
	if (link (temppath,path) == -1)
	{
		fprintf (stderr, "Unix2Dos: Problems renaming '%s' to '%s'\n", temppath, path);
		fprintf (stderr, "          However, file '%s' remains\n", temppath);
		exit (1);
	}
	unlink (temppath);
	return FALSE;
}
	
		
	

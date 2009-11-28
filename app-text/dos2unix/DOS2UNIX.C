/*
 *                              DOS2UNIX.C
 *
 * Clean out cr/lf combinations in a file but keep it's original
 * date/time stamp.
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
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


int dos2u (char *path);


main (int argc, char **argv)
{
	char *path;
	while (--argc>0)
	{
		if (stat (path=*++argv, &s_buf) != -1)
		{
			printf ("Dos2Unix: Cleaning file %s ...\n", path);
			if (dos2u (path))
			{
				fprintf (stderr, "Dos2Unix: Problems cleaning file %s\n", path);
			}
		}
		else
		{
			fprintf (stderr, "Dos2Unix: Can't stat '%s'\n", path);
		}
	}
}




	
		
	
int dos2u (char *path)
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
		if ((ch != '\015' && ch != '\032') &&
			(putc (ch, out) == EOF)           )
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
		fprintf (stderr, "Dos2Unix: Problems renaming '%s' to '%s'\n", temppath, path);
		fprintf (stderr, "          However, file '%s' remains\n", temppath);
		exit (1);
	}
	unlink (temppath);
	return FALSE;
}


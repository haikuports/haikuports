#include <stdlib.h>
#include <stdio.h>
#include <limits.h>

int main(int argc, char* argv[])
{
	if (argc < 2) {
		system("alert --stop \"Java: Please specify a Jarfile.\" >/dev/null");
		return 1;
	}

	char command[PATH_MAX];
	snprintf(command, sizeof(command), "%s -jar \"%s\"", JAVA_BINARY, argv[1]);

	FILE* fd = popen(command, "r");
	if (fd != NULL) {
		char buffer[512];
		fgets(buffer, 512, fd);
		return pclose(fd);
	} else
		system("alert --stop \"Java: popen failed!\" >/dev/null");

	return 1;
}

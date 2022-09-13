/*
 * Copyright 2018, Your Name <victor@email.address>
 * All rights reserved. Distributed under the terms of the GNU GPL v2 license.
 */
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <FindDirectory.h>
#include <fs_info.h>

int main(int argc, char* argv[]) {
	argv[argc] = (char*) 0;
	
	dev_t volume = dev_for_path("/boot");
	char cmd[B_PATH_NAME_LENGTH+B_FILE_NAME_LENGTH];
	find_directory(B_SYSTEM_DATA_DIRECTORY, volume, false, cmd, sizeof(cmd));
	strcat(cmd, "/7kaa/7kaaLauncher.sh");
	
	int ret = execvp(cmd, argv);
	if(ret == -1) {
		printf("Could not start the launcher! Command: %s", cmd);
		return 1;
	}
	
	return ret;
}


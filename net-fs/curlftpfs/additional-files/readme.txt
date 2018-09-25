CurlFtpFS needs a file system wrapper called UserlandFS which is available as an optional package on Haiku for most primary architectures from the corresponding Haiku repository. That package provides FUSE capability, which is needed by CurlFtpFS.

If /system/servers/userlandfs_server is missing on your system then this means the userland_fs package is not installed. You can install that package using the HaikuDepot application or by typing the following command on a Terminal window:
pkgman install userland_fs

At the moment the integration of CurlFtpFS is either not finished or not fully tested.
This means you might need to follow these steps to use it:

First start the userland_fs server:
	/system/servers/userlandfs_server curlftpfs &

Then mount an ftp share:
mount -t userlandfs -p 'curlftpfs -o option1,option2 \
	ftp://someserver.somewhere/some/directory' /local/mount/directory

curlftpfs has a manual page which lists all possible options, including support for SSLv3, TLSv1, proxies and many more.

#/bin/sh

# Rebuilds the KService desktop file system configuration cache.

kbuildsycoca5 --noincremental || true
kbuildsycoca5_x86 --noincremental || true

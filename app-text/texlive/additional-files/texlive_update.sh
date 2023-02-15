#!/bin/bash

notify --group "TexLive" --title "Installation in progress" --messageID texliveInstallID --timeout 10000 "Updating TeXLive filename database…"
mktexlsr

notify --group "TexLive" --title "Installation in progress" --messageID texliveInstallID --timeout 10000 "Updating TeXLive format files…"
fmtutil-sys --all

#mtxrun --generate
notify --group "TexLive" --title "Installation in progress" --messageID texliveInstallID --timeout 10000 "Updating TeXLive font maps…"
updmap-sys

notify --group "TexLive" --title "Installation finished" --messageID texliveInstallID  "Took long enough...!"

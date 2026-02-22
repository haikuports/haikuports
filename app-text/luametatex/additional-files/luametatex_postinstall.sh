#!/bin/bash

notify --group "TeXLive" --title "Installation in progress" --messageID texliveInstallID --timeout 10000 "Updating TeXLive ConTeXt formats…"
mtxrun --generate

notify --group "TeXLive" --title "Installation in progress" --messageID texliveInstallID --timeout 10000 "Updating TeXLive LuaTeX ConTeXt formats…"
mtxrun --luatex --generate

notify --group "TeXLive" --title "Installation finished" --messageID texliveInstallID  "Took long enough…!"

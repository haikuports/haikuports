#!/bin/bash

mktexlsr
fmtutil-sys --all
#mtxrun --generate
updmap-sys


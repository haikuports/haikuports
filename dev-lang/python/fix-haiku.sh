#!/bin/sh
find . -name '*.py' -exec sed -i -e 's|/usr/bin/env|/bin/env|g' {} \;

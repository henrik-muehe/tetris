#!/bin/bash

perl -p -e 's#^[\s\t]*\n##g' | \
grep -v -E "^(\t|\s)*#" | \
perl -p -e 's#: =>#:=>#g' | \
perl -p -e 's#: ->#:->#g'


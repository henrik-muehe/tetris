#!/bin/bash

perl -p -e 's#^[\s\t]*\n##g' | \
grep -v -E "^(\t|\s)*#" | \
perl -p -e 's#: =>#:=>#g' | \
perl -p -e 's#: ->#:->#g' | \
perl -p -e 's#shape#S#g' | \
perl -p -e 's#color#C#g' | \
perl -p -e 's#clone#E#g' | \
perl -p -e 's#draw#D#g' | \
perl -p -e 's#rotR#R#g' | \
perl -p -e 's#down#D#g' | \
perl -p -e 's#blocks#B#g' | \
perl -p -e 's#check#c#g' | \
perl -p -e 's#rowsKilled#v#g' | \
perl -p -e 's#score#J#g' | \
perl -p -e 's#gameover#o#g' | \
perl -p -e 's#^.*STYLE_ONLY.*$##g'

#!/bin/bash -e

set -o xtrace

if [ -z "$n" ]; then
	echo "Please set \$n"
	exit 1
fi

rm -f src/Runner.o src/Runner.hi
cpp -DN=$n src/Runner.hs.in > src/Runner.hs
mkdir -p dump-$n
sed -i '/^#/d' src/Runner.hs
$ghc -isrc Runner \
	-XTypeOperators -XKindSignatures -XDataKinds -XFlexibleInstances -XConstraintKinds \
	-XFlexibleContexts -XMultiParamTypeClasses -XTypeFamilies \
	-dumpdir dump-$n $@ >| dump-$n/log 2>&1

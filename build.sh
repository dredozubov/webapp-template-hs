#!/bin/bash -e

n=$1
shift
rm -f src/Runner.o src/Runner.hi
cpp -DN=$n src/Runner.hs.in > src/Runner.hs
mkdir -p dump-$n
$ghc -isrc Runner \
	-XTypeOperators -XKindSignatures -XDataKinds -XFlexibleInstances -XConstraintKinds \
	-XFlexibleContexts -XMultiParamTypeClasses -XTypeFamilies \
	-dumpdir dump-$n $@ >| dump-$n/log 2>&1


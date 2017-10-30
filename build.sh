#!/bin/bash

n=$1
shift
rm -f src/Runner.o src/Runner.hi
cpp -DN=$n src/Runner.hs.in > src/Runner.hs
ghc -DN=$n -isrc Runner -XTypeOperators -XKindSignatures -XDataKinds -XFlexibleInstances -XConstraintKinds -XFlexibleContexts -XMultiParamTypeClasses -XTypeFamilies -dumpdir dump-$n $@ 2>&1 | tee dump-$n/log

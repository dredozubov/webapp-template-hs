#!/bin/bash -ex

args="-O1 -fsimpl-tick-factor=1000 -v -dverbose-core2core -ddump-to-file -dsuppress-uniques -dsuppress-ticks -dsuppress-idinfo"
for i in 1 2 3 4 5 6 7; do 
    ./build.sh $i $args
    rm -Rf dump-$i/src/Runner.verbose-core2core.split || true
    ~/ghc-utils/split-core2core.py dump-$i/src/Runner.verbose-core2core
done


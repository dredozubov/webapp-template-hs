#!/bin/bash -ex

args="-O1 -fsimpl-tick-factor=1000 -v -dverbose-core2core -ddump-to-file -dsuppress-ticks -ddump-simpl-stats -dsuppress-idinfo -dsuppress-coercions"

for i in 1 2 3 4 5 6 7 8 9 10; do
    n=$i ./build.sh $args $@
    rm -Rf dump-$i/src/Runner.verbose-core2core.split || true
    wget https://raw.githubusercontent.com/dredozubov/ghc-utils/python-fixes/split-core2core.py && ./split-core2core.py dump-$i/src/Runner.verbose-core2core
done

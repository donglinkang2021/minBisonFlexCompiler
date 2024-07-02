#!/bin/bash
cmake -S . -B build
cmake --build build
for i in {1..8}; do
    filename="samples/cases/e$(printf "%02d" $i).c"
    ansfile="samples/answers/e$(printf "%02d" $i).ans"
    asmfile="samples/output/e$(printf "%02d" $i).s"
    outputfile="samples/output/e$(printf "%02d" $i).out"

    echo "Evaluating file: $filename"

    ./build/calc $filename > $asmfile
    gcc -m32 -no-pie $asmfile -o output/test
    ./output/test > $outputfile

    diff $outputfile $ansfile
done

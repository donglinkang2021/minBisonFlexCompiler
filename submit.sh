#!/bin/bash
cmake -S . -B build
cmake --build build
test_dir="samples2"
for i in {1..8}; do
    filename="$test_dir/cases/e$(printf "%02d" $i).c"
    ansfile="$test_dir/answers/e$(printf "%02d" $i).ans"
    asmfile="$test_dir/output/e$(printf "%02d" $i).s"
    outputfile="$test_dir/output/e$(printf "%02d" $i).out"

    echo "Evaluating file: $filename"

    ./build/calc $filename > $asmfile
    gcc -m32 -no-pie $asmfile -o output/test
    ./output/test > $outputfile

    diff $outputfile $ansfile
done
